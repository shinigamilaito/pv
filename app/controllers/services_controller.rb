class ServicesController < ApplicationController
  def new
    @service = Service.new
    @folios = []
    clear_session_variables
  end

  def create
    clear_session_variables
    folio = params[:service][:folio]
    folio = folio.gsub(' ','')
    folio = folio.split('-')[0]
    folios = Service.all.map(&:folio)

    unless folios.include?(folio)
      @service = Service.new(service_params)
      @service.user = current_user
      @folios = folios
      @folios << @service.folio

      if @service.save(validate: false)
        @message = 'Registro creado exitosamente.'
        session[:service_id] ||= @service.id
        render 'create', status: :created
      else
        render 'new', status: :unprocessable_entity
      end
    else
      # Folio proporcionado esta en uso
      @service = Service.where(client_id: params[:service][:client_id], folio: folio).first

      if @service.blank?
        @service = Service.new(service_params)
        @folios = (Service.find_folios(params[:service][:client_id]))[:folios_present]
        render 'new', status: :unprocessable_entity
      else
        @message = 'Servicio encontrado exitosamente.'
        session[:service_id] ||= @service.id
        render 'create', status: :ok
      end

    end
  end

  def find_folios
    @folios = (Service.find_folios(params[:client][:id].to_i))[:folios_present]
  end

  def add_spare_part
    session[:spare_part_ids] ||= []
    session[:worforce] ||= BigDecimal.new("0.00".gsub(",",""))
    session[:discount] ||= BigDecimal.new("0.00".gsub(",",""))

    @spare_part = SparePart.find(params[:spare_part][:id])
    get_service_from_session

    session[:spare_part_ids] << @spare_part.id unless session[:spare_part_ids].include?(@spare_part.id)

    generate_totals
  end

  def update_worforce
    session[:worforce] = BigDecimal.new(params[:worforce].gsub(",",""))
    get_service_from_session

    if session[:spare_part_ids].present?
      generate_totals
      render 'add_spare_part'
    else
      head :ok
    end
  end

  def update_discount
    session[:discount] = BigDecimal.new(params[:discount].gsub(",",""))
    get_service_from_session

    if session[:spare_part_ids].present?
      generate_totals
      render 'add_spare_part'
    else
      head :ok
    end
  end

  def update
    @service = Service.find(params[:id])
    spare_parts_used = SparePart.find(session[:spare_part_ids])
    service_spare_parts = ServiceSparePart.create_spare_parts_used(spare_parts_used)

    @service.service_spare_parts = service_spare_parts
    @service.paid = true
    clear_session_variables

    if @service.update(service_params)      
      render 'update'
    else
      flash.now[:error] = "Proporcione los datos correctos."
      render "form_paid"
    end
  end

  private

  def service_params
    params.require(:service).permit(:client_id, :folio, :payment_type_id,
      :date_of_entry, :worforce, :discount, :departure_date, :image_client)
  end

  def generate_totals
    @spare_parts = SparePart.find(session[:spare_part_ids])

    total_worforce = BigDecimal.new(session[:worforce])
    total_discount = BigDecimal.new(session[:discount])

    @totals = Service.generate_totals(@spare_parts, total_worforce, total_discount)
  end

  def clear_session_variables
    session[:spare_part_ids] = nil
    session[:worforce] = nil
    session[:discount] = nil
    session[:service_id] = nil
  end

  def get_service_from_session
    unless session[:service_id].blank?
      @service = Service.find(session[:service_id])
    else
      @service = Service.new
    end
  end
end
