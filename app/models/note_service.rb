class NoteService
  attr_accessor :service

  def initialize(service)
    @service = service
  end

  def folio
    "%06d" % service.number_folio
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
      mobile_phone: client_mobile_phone,
      email: client_email
    }
  end

 def equipment_customers
   service.equipment_customers.order(created_at: :desc)
 end

 private

 def client_name
   service.client.formal_name
 end

 def client_address
   service.client.address
 end

def client_home_phone
  service.client.home_phone || ""
end

def client_mobile_phone
  service.client.mobile_phone || ""
end

def client_email
  if service.client.email.nil?
    return " "
  else
    return service.client.email || ""
  end
end

end
