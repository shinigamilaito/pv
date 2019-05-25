class PrintingProductsPolicy
  attr_accessor :source_product, :destination_product, :unit_to_discount

  def initialize(source_product, destination_product, unit_to_discount)
    self.source_product = source_product
    self.destination_product = destination_product
    self.unit_to_discount = unit_to_discount
  end

  def self.sale_units
    return %w(Pieza Paquete Metro Bolsa Caja Juego Rollo)
  end

  def self.contains_unit
    return %w(Piezas Metros)
  end

  def stock_enough?
    total_available = (source_product.stock * source_product.contains) - source_product.discount_stock
    total_pending = self.unit_to_discount

    if total_available >= total_pending
      return true
    else
      return false
    end
  end

  def transfer
    PgLock.new(name: "printing_products_policy_transfer").lock do
      ActiveRecord::Base.transaction do
        unit_by_discount = self.unit_to_discount + source_product.discount_stock
        discount_in_stock = unit_by_discount / source_product.contains
        new_discount_in_process = unit_by_discount - (discount_in_stock * source_product.contains)

        self.source_product.stock -= discount_in_stock
        self.source_product.discount_stock = new_discount_in_process

        self.destination_product.stock += self.unit_to_discount

        raise 'Error al actalizar el stock' unless self.source_product.save
        raise 'Error al actualizar el stock' unless self.destination_product.save
      end
    end
  end
end
