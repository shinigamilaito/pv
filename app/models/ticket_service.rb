class TicketService < Ticket
  attr_accessor :payment

  def initialize(payment)
    @payment = payment
  end

  def ticket
    payment.ticket
  end

  def date
      ActionController::Base.helpers.l(payment.updated_at, format: '%A, %d %b %Y %I:%M:%S')
  end

  def folio
    payment.service.number_folio
  end

  def spare_parts
    spare_parts = []
    spare_parts_sell.each { |local_spare_part| spare_parts << public_data(local_spare_part) }
    spare_parts << worforce
    spare_parts
  end

  def type_paid
    payment.payment_type.name
  end

  private

  def spare_parts_sell
    payment.service_spare_parts.order(:created_at)
  end

  def worforce
    {
      code: '',
      quantity: 1,
      description: 'Mano de Obra',
      price: payment.real_worforce,
      total: payment.real_worforce
    }
  end

  def sucursal
    'Servicio'
  end

  def paid
    payment.paid_with
  end

  def change
    payment.change
  end

  def public_data(spare_part)
    {
      code: spare_part.control_number,
      quantity: spare_part.quantity,
      description: name_ticket(spare_part),
      price: spare_part.price,
      total: total_cost(spare_part)
    }
  end

  def name_ticket(spare_part)
    return spare_part.description unless spare_part.description.empty?

    spare_part.name
  end

  def total_cost(spare_part)
    BigDecimal(spare_part.price * spare_part.quantity)
  end

  def total_to_paid
    return @totals if @totals.present?

    total_calculator = TotalCalculator.new(payment.service, payment)
    total_calculator.worforce = payment.real_worforce
    total_calculator.discount = payment.discount

    @totals = total_calculator.totals
  end

end
