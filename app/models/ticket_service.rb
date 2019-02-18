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
    service.folio
  end

  def spare_parts
    spare_parts = []
    spare_parts_sell.each { |local_spare_part| spare_parts << local_spare_part.public_data }
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
    service.type_paid
  end

  private

  def spare_parts_sell
    service.spare_parts
  end

  def worforce
    {
      code: '',
      quantity: 1,
      description: 'Mano de Obra',
      price: service.worforce,
      total: service.worforce
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
    service.generate_totals(service.worforce, service.discount)[:total_products]
  end

  def discount
    service.generate_totals(service.worforce, service.discount)[:total_discount]
  end

  def iva
    BigDecimal('0.00')
  end

  def total
    service.generate_totals(service.worforce, service.discount)[:total_final]
  end

  def paid
    BigDecimal('500.0')
  end

  def change
    BigDecimal('25.50')
  end
end
