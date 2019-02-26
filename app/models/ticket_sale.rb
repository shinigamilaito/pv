class TicketSale < Ticket
  attr_accessor :sale, :paid_with, :change_sale, :discount_percentaje

  def initialize(sale, paid_with, change_sale, discount_percentaje)
    @sale = sale
    @paid_with = BigDecimal.new(paid_with)
    @change_sale = BigDecimal.new(change_sale)
    @discount_percentaje = BigDecimal.new(discount_percentaje)
  end

  def ticket
    if sale.class == Sale
      sale.total_tickets
    else
      ''
    end
  end

  def products
    products = []
    products_sell.each { |local_product| products << public_data(local_product) }

    products
  end

  def type_paid
    'Efectivo'
  end

  private

  def products_sell
    if sale.class == Sale
      sale.sale_products.order(created_at: :desc)
    else
      sale.sale_products.where(sale_id: nil).order(created_at: :desc)
    end
  end

  def sucursal
    'Accesorios'
  end

  def paid
    if sale.class == Sale
      sale.paid_with
    else
      paid_with
    end
  end

  def change
    if sale.class == Sale
      sale.change
    else
      change_sale
    end
  end

  def public_data(product)
    {
      code: product.code,
      quantity: product.quantity,
      description: product.name,
      price: product.price,
      total: total_cost(product)
    }
  end

  def total_cost(product)
    BigDecimal(product.price * product.quantity)
  end

  def total_to_paid
    return @totals if @totals.present?
    total_calculator = TotalCalculatorSale.new(sale, paid_with, change_sale, discount_percentaje)

    @totals = total_calculator.totals
  end

  def sub_total
    total_to_paid[:total_products]
  end

  def total
    total_to_paid[:total_final]
  end

  def discount
    total_to_paid[:total_discount]
  end

end
