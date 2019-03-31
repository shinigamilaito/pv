class Ticket

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

  def totals
    {
      subtotal: sub_total,
      discount: discount,
      total: total,
      paid: paid,
      change: change
    }
  end

  def ticket
    ''
  end

  private

  def title
    'PC TIENDA & REPARACIÓN'
  end

  def street
    'Calle 16 de Septiembre No. 6'
  end

  def address
    'Col. Centro, CP 69000'
  end

  def city
    'Huajuapan, Oax.'
  end

  def rfc
    'TTTT9999999ED'
  end

  def sub_total
    total_to_paid[:total_final]
  end

  def discount
    total_to_paid[:total_discount]
  end

  def total
    sub_total - discount
  end

end
