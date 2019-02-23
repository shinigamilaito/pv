class TicketService
  attr_accessor :service

  def initialize(service)
    @service = service
  end

  def header
    {
      title: title,
      street: street,
      address: address,
      city: city,
      rfc: rfc,
      sucursal: sucursal
    }
  end

  def date
      Time.now.strftime('%A, %d %b %Y %I:%M:%S')
  end

  def ticket
    '0001'
  end

  def folio
    service.number_folio
  end

  def spare_parts
    spare_parts = []
    spare_parts_sell.each { |local_spare_part| spare_parts << public_data(local_spare_part) }
    spare_parts << worforce
    spare_parts
  end

  def totals
    {
      subtotal: sub_total,
      discount: discount,
      iva: iva,
      total: total,
      paid: paid,
      change: change
    }
  end

  def type_paid
    service.payment_type.name
  end

  private

  def spare_parts_sell
    service.service_spare_parts.order(:created_at)
  end

  def worforce
    {
      code: '',
      quantity: 1,
      description: 'Mano de Obra',
      price: service.real_worforce,
      total: service.real_worforce
    }
  end

  def title
    'PC TIENDA & REPARACIÓN'
  end

  def street
    'Calle 16 de Septiembre No. 6 y 3'
  end

  def address
    'Col. Centro, México, CP 69000'
  end

  def city
    'Heroica Ciudad de Huajuapan de León, Oaxaca'
  end

  def rfc
    'TTTT9999999ED'
  end

  def sucursal
    'Servicio'
  end

  def sub_total
    total_to_paid[:total_products]
  end

  def discount
    total_to_paid[:total_discount]
  end

  def iva
    BigDecimal('0.00')
  end

  def total
    total_to_paid[:total_final]
  end

  def paid
    BigDecimal('500.0')
  end

  def change
    BigDecimal('25.50')
  end

  def public_data(spare_part)
    {
      code: '0001',
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

    total_calculator = TotalCalculator.new(service)
    total_calculator.worforce = service.real_worforce
    total_calculator.discount = service.discount

    @totals = total_calculator.totals
  end
end
