class ServicesPolicy
  attr_accessor :client_id

  def initialize(client_id = '')
    @client_id = client_id
  end

  def find_folios
    services = Service.where(client_id: client_id).order(created_at: :desc)
    folios_hash = {}
    folios_hash[:folios] = services.map(&:folio)
    folios_hash[:folios_present] = services.map do |service|
       folios_with_date_creation(service)
    end

    folios_hash
  end

  def create(service_params, user)
    folio = service_params[:folio].gsub(' ','').split('-')[0]
    folios = Service.pluck(:folio)
    unless folios.include?(folio)
      service = Service.new({
        client_id: service_params[:client_id],
        folio: folio
      })
      service.user = user
      return service
    else
      # Folio proporcionado esta en uso
      service = Service.where(client_id: client_id, folio: folio).first

      if service.new_record?
        raise 'Código ya en uso'
      else
        service.employee = user
        return service
      end
    end
  end

  def folios_with_date_creation(service)
    paided = service.paid ? 'PAGADO' : 'EN PROCESO'
    return "#{service.folio} - Creado: #{service.created_at.strftime('%A, %d %b %Y %I:%M:%S')}. #{paided}"
  end

  def paid(service_params, user)
    service = Service.find(service_params[:id])
    service.user = user
    service.paid = true
    price = service_params[:price]

    if service_params[:from_generic_price].eql?('true')
      generic_price = GenericPrice.find(price)
      service.generic_price = generic_price
      service.worforce = BigDecimal.new('0.00')
    else
      service.worforce = BigDecimal.new(price)
      service.generic_price = nil
    end

    service
  end

end
