class TicketQuotationPrinting < Ticket
  attr_accessor :quotation_printing

  def initialize(quotation_printing)
    @quotation_printing = quotation_printing
  end

  def ticket
    quotation_printing.ticket
  end

  def date
    ActionController::Base.helpers.l(quotation_printing.updated_at, format: '%A, %d %b %Y')
  end

  def type_paid
    quotation_printing.payment_type.name
  end

  def payment
    quotation_printing.payment
  end

  def difference
    quotation_printing.difference
  end

  def total_payments
    return quotation_printing.payment  #+ quotation_printing.partial_payment_quotation_printings.map(&:payment).sum
  end

  private

  def sucursal
    'Imprenta'
  end

  def paid
    quotation_printing.paid_with
  end

  def change
    quotation_printing.change
  end

  def total_to_paid
    total_products = quotation_printing.total_quotations
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
