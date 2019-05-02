class NoteQuotation
  attr_accessor :quotation

  def initialize(quotation)
    @quotation = quotation
  end

  def folio
    "%06d" % quotation.folio
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

 def equipment_customers
   quotation.quotation_products.order(created_at: :desc)
 end

 def totals
   total = equipment_customers.inject(BigDecimal("0.00")) do |total, product|
     total += product.total
     total
   end

   total
 end

 def valid_until
   next_month = quotation.created_at + 1.month
   next_month
 end

 private

 def client_name
   quotation.client.formal_name
 end

 def client_address
   quotation.client.address
 end

def client_home_phone
  quotation.client.home_phone
end

def client_mobile_phone
  quotation.client.mobile_phone
end

def client_email
  if quotation.client.email.nil?
    return " "
  else
    return quotation.client.email || ""
  end
end

end
