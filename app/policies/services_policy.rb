class ServicesPolicy
  attr_accessor :client_id

  NEW_NOTE = 'NUEVA NOTA'

  def initialize(client_id = '')
    @client_id = client_id
  end

  def find_folios
    services = Service.where(client_id: client_id).order(created_at: :desc)
    folios_hash = {}
    folios_hash[:folios] = services.map(&:number_folio)
    folios_hash[:folios_present] = services.map do |service|
       folios_with_date_creation(service)
    end

    folios_hash[:folios_present].unshift(NEW_NOTE)
    folios_hash
  end

  def create(service_params, user)
    folio = service_params[:number_folio].gsub(' ','').split('-')[0].to_i
    folios = Service.pluck(:number_folio).sort
    unless folios.include?(folio)
      service = Service.new({
        client_id: service_params[:client_id],
        number_folio: Service.count + 1
      })
      service.user = user
      return service
    else
      # Folio proporcionado esta en uso
      service = Service.where(client_id: client_id, number_folio: folio).first

      if service.new_record?
        raise 'Código ya en uso'
      else
        return service
      end
    end
  end

  def folios_with_date_creation(service)
    paided = service.is_in_process? ? 'EN PROCESO' : 'PAGADO'
    date = ActionController::Base.helpers.l(service.created_at, format: '%A, %d %b %Y %I:%M:%S')
    return "#{service.number_folio} - Creado: #{date}. #{paided}"
  end

  def self.pending_services
    Service.joins(:equipment_customers)
           .where("equipment_customers.payment_id IS NULL")
  end

end
