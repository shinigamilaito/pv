class TicketPartialSale < Ticket
  attr_accessor :partial_sale

  def initialize(partial_sale)
    @partial_sale = partial_sale
  end

  def ticket
    partial_sale.printing_sale.ticket
  end

  def date
    ActionController::Base.helpers.l(partial_sale.updated_at, format: '%A, %d %b %Y')
  end

  def type_paid
    partial_sale.payment_type.name
  end

  def payment
    partial_sale.payment
  end

  def difference
    partial_sale.difference
  end

  def total_payments
    partial_sales_policy = PartialSalesPolicy.new()
    partial_sales_policy.total_payments(partial_sale.printing_sale)
  end

  private

  def sucursal
    'Imprenta'
  end

  def paid
    partial_sale.paid_with
  end

  def change
    partial_sale.change
  end

  def total_to_paid
    partial_sales_policy = PartialSalesPolicy.new()
    total_products = partial_sales_policy.total(partial_sale.printing_sale)
    total_final = total_products

    return {
      total_products: total_products,
      total_final: total_final,
      paid_with: paid,
      change: change
    }
  end

  def sub_total
    total_to_paid[:total_products]
  end

  def total
    total_to_paid[:total_final]
  end

end
