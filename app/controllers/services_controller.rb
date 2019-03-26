class ServicesController < ApplicationController
  def new
    if params[:service_id].present?
      @service = Service.find(params[:service_id])
      service_policy = ServicesPolicy.new(@service.client_id)
      @folios = service_policy.find_folios[:folios_present]
      @folio = service_policy.folios_with_date_creation(@service)
      @components = Component.all.order(:created_at)
      payments_policy = PaymentsPolicy.new(@service)
      @payment = payments_policy.current_payment
      @equipments_not_paid = payments_policy.equipments_not_paid
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
      PgLock.new(name: "create_service").lock do
        @service = services_policy.create(params[:service], current_user)
        @folios = services_policy.find_folios[:folios_present]
        @components = Component.all.order(:created_at)
        payments_policy = PaymentsPolicy.new(@service)
        @payment = payments_policy.current_payment
        @equipments_not_paid = payments_policy.equipments_not_paid

        if @service.new_record?
          if @service.save(validate: false)
            @folios = services_policy.find_folios[:folios_present]
            @folio = services_policy.folios_with_date_creation(@service)
            @message = 'Registro creado exitosamente.'
            session[:service_id] ||= @service.id
            render 'create', status: :created
          else
            raise 'Error al registrar el servicio.'
          end
        else
          @folios = services_policy.find_folios[:folios_present]
          @folio = services_policy.folios_with_date_creation(@service)
          @message = 'Servicio encontrado exitosamente.'
          session[:service_id] ||= @service.id
          render 'create', status: :ok
        end
      end
    rescue StandardError => e
      @service = Service.new(service_params)
      @folios = services_policy.find_folios[:folios_present]
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @service = Service.find(params[:id])
    payments_policy = PaymentsPolicy.new(@service)
    if payments_policy.save_image(params[:image_client])
      render js: "toastr['success']('Foto exitosamente guardada.');", status: :created
    else
      render js: "toastr['error']('Intente nuevamente.');", status: :bad_request
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
      @payment = PaymentsPolicy.new(@service).current_payment
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def update_worforce
    session[:worforce] = BigDecimal.new(params[:worforce].gsub(',',''))
    @service = Service.find(params[:service_id])
    generate_totals
    @payment = PaymentsPolicy.new(@service).current_payment
    render 'add_spare_part'
  end

  def update_discount
    session[:discount] = BigDecimal.new(params[:discount].gsub(',',''))
    @service = Service.find(params[:service_id])
    @payment = PaymentsPolicy.new(@service).current_payment
    generate_totals
    render 'add_spare_part'
  end

  def update_quantity
    new_quantity = params[:quantity].to_i
    service_spare_part = ServiceSparePart.find(params[:service_spare_part_id])
    spare_part_service = SparePartService.new
    begin
      if spare_part_service.update_quantity(new_quantity, service_spare_part)
        @service = service_spare_part.service
        generate_totals
        @payment = PaymentsPolicy.new(@service).current_payment
        render 'add_spare_part'
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
      @payment = PaymentsPolicy.new(@service).current_payment
      generate_totals
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  private

  def service_params
    params.require(:service).permit(:client_id, :number_folio, :payment_type_id,
      :discount, :departure_date, :image_client, :paid_with, :change)
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
