class NoteQuotationPrinting
  attr_accessor :quotation_printing

  def initialize(quotation_printing)
    @quotation_printing = quotation_printing
  end

  def folio
    "%06d" % quotation_printing.number_folio
  end

  def street
    '16 de Septiembre # 3 Col. Centro'
  end

  def city
    'Huajuapan de Leon Oax. c.p. 69000'
  end

  def email
    'richar_1806@hotmail.com'
  end

  def telephones
    {
      one: 'Tel: 53 2 55 21',
      two: 'Tel: 53 0 09 29'
    }

  end

  def date
    Date.current.strftime("%d/%m/%Y")
  end

  def client
    {
      name: client_name,
      address: client_address,
      home_phone: client_home_phone,
      email: client_email
    }
  end

 def totals
   total = equipment_customers.inject(BigDecimal("0.00")) do |total, product|
     total += product.total
     total
   end

   total
 end

 def valid_until
   next_month = quotation_printing.created_at + 1.month
   next_month
 end

 def invitation_name
   @quotation_printing.invitation.name.upcase
 end

 def total_pieces
   quotation_printing.total_pieces
 end

 def cost_total_quotation
   quotation_printing.total_quotations
 end

 def payment_type
   quotation_printing.payment_type.name
 end

 def paid_with
   quotation_printing.paid_with
 end

 def payment
   quotation_printing.payment
 end

 def change
   quotation_printing.change
 end

 def difference
   quotation_printing.difference
 end

 def is_orden?
   quotation_printing.status.eql?("Orden de Trabajo")
 end

 private

 def client_name
   quotation_printing.client.formal_name
 end

 def client_address
   quotation_printing.client.address
 end

def client_home_phone
  quotation_printing.client.home_phone
end

def client_mobile_phone
  quotation_printing.client.mobile_phone
end

def client_email
  if quotation_printing.client.email.nil?
    return " "
  else
    return quotation_printing.client.email || ""
  end
end

end
