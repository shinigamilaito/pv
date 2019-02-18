class ServicesController < ApplicationController
  def new
    if params[:service_id].present?
      @service = Service.find(params[:service_id])
      @service.employee = current_user
      service_policy = ServicesPolicy.new(@service.client_id)
      @folios = service_policy.find_folios[:folios_present]
      @folio = service_policy.folios_with_date_creation(@service)
      @components = Component.all.order(:created_at)
    else
      @service = Service.new
      @folios = []
    end

    clear_variables
  end

  def create
    clear_variables
    services_policy = ServicesPolicy.new(params[:service][:client_id])
    begin
      @service = services_policy.create(params[:service], current_user)

      if @service.new_record?
        @folios = Service.pluck(:folio)
        @folios << @service.folio
        if @service.save(validate: false)
          @service.employee = current_user
          @components = Component.all.order(:created_at)
          @message = 'Registro creado exitosamente.'
          session[:service_id] ||= @service.id
          render 'create', status: :created
        else
          raise 'Error al registrar el servicio.'
        end
      else
        @components = Component.all.order(:created_at)
        @message = 'Servicio encontrado exitosamente.'
        session[:service_id] ||= @service.id
        render 'create', status: :ok
      end
    rescue StandardError => e
      @service = Service.new(service_params)
      @service.employee = current_user
      @folios = services_policy.find_folios[:folios_present]
      render 'new', status: :unprocessable_entity
    end
  end

  def find_folios
    service_policy = ServicesPolicy.new(params[:client][:id].to_i)
    @folios = service_policy.find_folios[:folios_present]
  end

  def add_spare_part
    @service = Service.find(params[:service_id])
    spare_part = SparePart.find(params[:spare_part][:id])
    spare_part_service = SparePartService.new(@service, spare_part)
    begin
      spare_part_service.add
      generate_totals
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def update_worforce
    session[:worforce] = BigDecimal.new(params[:worforce].gsub(',',''))
    @service = Service.find(params[:service_id])

    if @service.service_spare_parts.present?
      @totals = generate_totals
      render 'add_spare_part'
    else
      head :ok
    end
  end

  def update_discount
    session[:discount] = BigDecimal.new(params[:discount].gsub(',',''))
    @service = Service.find(params[:service_id])

    if @service.service_spare_parts.present?
      @totals = generate_totals
      render 'add_spare_part'
    else
      head :ok
    end
  end

  # paid the service
  def update
    services_policy = ServicesPolicy.new
    @service = services_policy.paid(params, current_user)
    clear_variables

    if @service.update(service_params)
      render 'update'
    else
      flash.now[:error] = 'Proporcione los datos correctos.'
      render 'form_paid'
    end
  end

  def update_quantity
    new_quantity = params[:quantity].to_i
    service_spare_part = ServiceSparePart.find(params[:service_spare_part_id])
    spare_part_service = SparePartService.new
    begin
      if spare_part_service.update_quantity(new_quantity, service_spare_part)
        render js: "toastr['success']('Stock actualizado correctamente.');", status: :ok
      else
        head :ok
      end
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def delete_spare_part
    spare_part_service = SparePartService.new
    service_spare_part = ServiceSparePart.find(params[:service_spare_part_id])
    @service = service_spare_part.service
    begin
      spare_part_service.delete(service_spare_part)
      generate_totals
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  private

  def service_params
    params.require(:service).permit(:client_id, :folio, :payment_type_id,
      :date_of_entry, :discount, :departure_date, :image_client, :employee_id)
  end

  def clear_variables
    session[:worforce] = nil
    session[:discount] = nil
  end

  def generate_totals
    session[:worforce] ||= BigDecimal.new('0.00'.gsub(',',''))
    session[:discount] ||= BigDecimal.new('0.00'.gsub(',',''))
    total_calculator = TotalCalculator.new(@service)
    total_calculator.worforce = BigDecimal.new(session[:worforce])
    total_calculator.discount = BigDecimal.new(session[:discount])
    @totals = total_calculator.totals
  end

end
