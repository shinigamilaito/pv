# Before made the printing sale
class PrintingSalesPolicy
  attr_reader :product_id, :user

  def initialize(product_id = '', user)
    @product_id = product_id
    @user = user
  end

  def add_product(quantity = 1, is_increment = true)
    PgLock.new(name: "printing_sales_policy_add_product").lock do
      new_product = false

      if printing_product.present?
        if available?(quantity, is_increment)
          if pending_in_sale?
            printing_product = adjust_product_in_sale(quantity, is_increment)
          else
            printing_product = adjust_new_product_to_sale
            new_product = true
          end
        else
          raise 'Producto no disponible.'
        end
      else
        raise 'Producto no encontrado.'
      end

      return {
        new: new_product,
        printing_product: printing_product
      }
    end
  end

  def products_for_sale
    user.printing_sale_products.where(printing_sale_id: nil).order(created_at: :desc)
  end

  def delete(printing_sale_product, printing_product)
    PgLock.new(name: "printing_sales_policy_delete").lock do
      ActiveRecord::Base.transaction do
        @printing_product = printing_product
        quantity = printing_sale_product.quantity
        raise 'Error al actualizar la cantidad.' unless adjust_quantity_product(quantity)
        raise 'Error al eliminar el producto.' unless printing_sale_product.destroy
      end
    end
  end

  def totals(discount = '0')
    total_products = cost_products
    total_discount = obtain_discount(discount)
    total_final = total_products - total_discount

    return {
      total_products: total_products,
      total_discount: total_discount,
      discount_percentage: discount,
      total_final: total_final,
      paid_with: BigDecimal.new('0'),
      change: BigDecimal.new('0')
    }
  end

  def remove_products_in_sale
    products_for_sale.each do |printing_sale_product|
      delete(printing_sale_product, printing_sale_product.printing_product)
    end
  end

  # Obtener el precio para el producto al aplicar
  # un descuento en porcentaje
  def obtain_discount_by_product(sale_product_id, discount_percentage)
    @sale_product = SaleProduct.find(sale_product_id)
    if discount_percentage != @sale_product.discount
      @sale_product.discount = discount_percentage
      #@sale_product.price -= (discount_percentage * @sale_product.price) / 100.0
      @sale_product.save
    end

    return @sale_product
  end

  # Actualiza el precio del producto
  # ajusta el nuevo porcentaje aplicado
  def change_price_product(sale_product_id, new_price)
    @sale_product = SaleProduct.find(sale_product_id)
    current_price = @sale_product.quantity * @sale_product.price

    new_discount = (new_price / current_price) * BigDecimal.new("100")
    @sale_product.discount = BigDecimal.new("100.0") - new_discount
    @sale_product.real_price = new_price / @sale_product.quantity
    @sale_product.save

    return @sale_product
  end

  private

  def adjust_product_in_sale(quantity, is_increment)
    ActiveRecord::Base.transaction do
      raise 'No fue posible ajustar la cantidad del producto.' unless adjust_quantity_sale_product(quantity, is_increment)
      raise 'No fue posible decrementar el stock' unless decrement_total_product(quantity)
      printing_sale_product
    end
  end

  def adjust_new_product_to_sale
    ActiveRecord::Base.transaction do
      printing_sale_product = new_sale_product
      printing_sale_product.user = user
      raise 'Producto no creado' unless printing_sale_product.save
      raise 'No fue posible decrementar el stock' unless decrement_total_product(1)
      printing_sale_product
    end
  end

  def printing_product
    @printing_product ||= PrintingProduct.find(product_id)
  end

  def available?(quantity, is_increment)
    if pending_in_sale?
      unless is_increment
        printing_product.stock + printing_sale_product.quantity >= quantity
      else
        printing_product.stock >= quantity
      end
    else
      printing_product.stock >= quantity
    end
  end

  def pending_in_sale?
    printing_sale_product.present?
  end

  def printing_sale_product
    @printing_sale_product ||= user.printing_sale_products.where(printing_product_id: product_id, printing_sale_id: nil).first
  end

  def new_sale_product
    printing_sale_product = PrintingSaleProduct.new
    printing_sale_product.code = printing_product.code
    printing_sale_product.name = printing_product.name
    printing_sale_product.quantity = 1
    printing_sale_product.price = printing_product.sale_price # Sin descuento
    printing_sale_product.real_price = printing_product.sale_price # Podria aplicarsele descuento
    printing_sale_product.printing_product = printing_product

    printing_sale_product
  end

  def adjust_quantity_sale_product(new_quantity, is_increment)
    if is_increment
      printing_sale_product.quantity += new_quantity
    else
      raise 'Error al ajustar el stock' unless adjust_quantity_product(printing_sale_product.quantity)
      printing_sale_product.quantity = new_quantity
    end
    printing_sale_product.save
  end

  def decrement_total_product(quantity)
    printing_product.stock -= quantity
    printing_product.save
  end

  # Se restablece la cantidad del producto
  # después de eliminarlo de la venta
  def adjust_quantity_product(quantity)
    printing_product.stock += quantity
    printing_product.save
  end

  def cost_products
    total = products_for_sale.inject(BigDecimal("0.00")) do |total, product|
      total += total_cost(product)
      total
    end

    total
  end

  def total_cost(product)
    BigDecimal(product.real_price * product.quantity)
  end

  def obtain_discount(discount)
    total_products = cost_products
    total_discount = BigDecimal.new(discount)
    total_percentaje = total_products * total_discount

    return (total_percentaje / BigDecimal.new('100.00'))
  end
end
