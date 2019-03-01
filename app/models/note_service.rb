class NoteService
  attr_accessor :service

  def initialize(service)
    @service = service
  end

  def folio
    "##{service.number_folio}"
  end

  def title
    'PC'
  end

  def subtitle
    'tienda & reparación'
  end

  def street
    '16 DE SEPTIEMBRE #6 COL. CENTRO'
  end

  def city
    'HUAJUAPAN DE LEÓN, OAX.'
  end

  def emails
    {
      one: email_one,
      two: email_two
    }
  end

  def telephone
    'TEL: 53 2 55 21'
  end

  def header
    'NOTA DE SERVICIO'
  end

  def date
    Date.current.strftime("%d/%m/%Y")
  end

  def client
    {
      name: client_name,
      address: client_address,
      home_phone: client_home_phone,
      mobile_phone: client_mobile_phone
    }
  end

 def equipment_customers
   service.equipment_customers.order(created_at: :desc)
 end

 private

 def email_one
   'richard_1806@hotmail.com'
 end

 def email_two
   'richard_1806@hotmail.com'
 end

 def client_name
   service.client.formal_name
 end

 def client_address
   service.client.address
 end

def client_home_phone
  service.client.home_phone
end

def client_mobile_phone
  service.client.mobile_phone
end

end
