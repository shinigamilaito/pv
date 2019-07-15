class TicketPrintingSale < Ticket
  attr_accessor :printing_sale, :paid_with, :change_sale, :payment_type

  def initialize(printing_sale, paid_with = '0', change_sale = '0', payment_type = PaymentType.new)
    @printing_sale = printing_sale
    @paid_with = BigDecimal.new(paid_with)
    @change_sale = BigDecimal.new(change_sale)
    @payment_type = payment_type
  end

  def ticket
    printing_sale.ticket
  end

  def date
    ActionController::Base.helpers.l(printing_sale.updated_at, format: '%A, %d %b %Y')
  end

  def products
    products = []
    products_sell.each { |local_product| products << public_data(local_product) }

    products
  end

  def type_paid
    printing_sale.payment_type.name
  end

  def parcial_payment?
    !printing_sale.full_payment
  end

  def payment
    printing_sale.payment
  end

  def difference
    printing_sale.difference
  end

  def client
    printing_sale.client.formal_name
  end

  private

  def products_sell
    printing_sale.printing_sale_products.order(created_at: :desc)
  end

  def sucursal
    'Imprenta'
  end

  def paid
    printing_sale.paid_with
  end

  def change
    printing_sale.change
  end

  def public_data(product)
    {
      code: product.code,
      quantity: product.quantity,
      description: product.name,
      price: product.real_price,
      total: total_cost(product)
    }
  end

  def total_cost(product)
    BigDecimal(product.real_price * product.quantity)
  end

  def total_to_paid
    return @totals if @totals.present?
    total_calculator = TotalCalculatorPrintingSale.new(printing_sale, paid_with, change_sale)

    @totals = total_calculator.totals
  end

  def sub_total
    total_to_paid[:total_products]
  end

  def total
    total_to_paid[:total_final]
  end

end
