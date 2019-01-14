class ServicesController < ApplicationController
  def new
    @service = Service.new
    @folios = []
  end

  def create
    folio = params[:service][:folio]
    folio = folio.gsub(' ','')
    folio = folio.split('-')[0]
    folios_hash = Service.find_folios(params[:service][:client_id])
    folios = folios_hash[:folios]

    unless folios.include?(folio)
      @service = Service.new(service_params)
      @service.user = current_user
      @folios = folios_hash[:folios_present]
      @folios << @service.folio

      if @service.save
        @message = 'Registro creado exitosamente.'
        render 'create', status: :created
      else
        render 'new', status: :unprocessable_entity
      end
    else
      @service = Service.where(client_id: params[:service][:client_id], folio: folio).first
      @message = 'Servicio encontrado exitosamente.'
      render 'create', status: :ok
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
    session[:spare_part_ids] << @spare_part.id unless session[:spare_part_ids].include?(@spare_part.id)

    generate_totals
  end

  def update_worforce
    session[:worforce] = BigDecimal.new(params[:worforce].gsub(",",""))

    if session[:spare_part_ids].present?
      generate_totals
      render 'add_spare_part'
    else
      head :ok
    end
  end

  def update_discount
    session[:discount] = BigDecimal.new(params[:discount].gsub(",",""))

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
    if @service.update(service_params)
      flash[:success] = "Pago registrado exitosamente."
      redirect_to new_service_path
    else
      flash.now[:error] = "Proporcione los datos correctos."
      render "equipment_customers/show"
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
end
