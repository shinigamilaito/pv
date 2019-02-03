class ServicesController < ApplicationController
  def new
    if params[:service_id].present?
      @service = Service.find(params[:service_id])
      @service.employee = current_user
      @folios = (Service.find_folios(@service.client_id)[:folios_present])
      clear_session_variables
    else
      @service = Service.new
      @folios = []
      clear_session_variables
    end
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
        @service.employee = current_user
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
        @service.employee = current_user
        @folios = (Service.find_folios(params[:service][:client_id]))[:folios_present]
        render 'new', status: :unprocessable_entity
      else
        @service.employee = current_user
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
    session[:worforce] ||= BigDecimal.new('0.00'.gsub(',',''))
    session[:discount] ||= BigDecimal.new('0.00'.gsub(',',''))

    @service = Service.find(params[:service_id])
    spare_part = SparePart.find(params[:spare_part][:id])
    spare_part.decrement_total()
    service_spare_part = ServiceSparePart.new_from(spare_part)
    service_spare_part.service = @service
    service_spare_part.save

    total_worforce = BigDecimal.new(session[:worforce])
    total_discount = BigDecimal.new(session[:discount])

    @totals = @service.generate_totals(total_worforce, total_discount)
  end

  def update_worforce
    session[:worforce] = BigDecimal.new(params[:worforce].gsub(',',''))
    session[:discount] ||= BigDecimal.new('0.00'.gsub(',',''))

    total_worforce = BigDecimal.new(session[:worforce])
    total_discount = BigDecimal.new(session[:discount])

    @service = Service.find(params[:service_id])

    if @service.service_spare_parts.present?
      @totals = @service.generate_totals(total_worforce, total_discount)
      render 'add_spare_part'
    else
      head :ok
    end
  end

  def update_discount
    session[:discount] = BigDecimal.new(params[:discount].gsub(',',''))
    session[:worforce] ||= BigDecimal.new('0.00'.gsub(',',''))

    total_worforce = BigDecimal.new(session[:worforce])
    total_discount = BigDecimal.new(session[:discount])

    @service = Service.find(params[:service_id])

    if @service.service_spare_parts.present?
      @totals = @service.generate_totals(total_worforce, total_discount)
      render 'add_spare_part'
    else
      head :ok
    end
  end

  def update
    @service = Service.find(params[:id])
    @service.user = current_user
    spare_parts_used = SparePart.find(session[:spare_part_ids])
    service_spare_parts = ServiceSparePart.create_spare_parts_used(spare_parts_used)

    @service.service_spare_parts = service_spare_parts
    @service.paid = true

    if params[:from_generic_price].eql?('true')
      generic_price = GenericPrice.find(params[:price])
      @service.generic_price = generic_price
    else
      @service.worforce = BigDecimal.new(params[:price])
    end

    clear_session_variables

    if @service.update(service_params)
      render 'update'
    else
      flash.now[:error] = 'Proporcione los datos correctos.'
      render 'form_paid'
    end
  end

  def generate_ticket
    respond_to do |format|
      format.pdf do
        @service = Service.find(params[:id])
        render pdf: 'report',
               #wkhtmltopdf: route_wicked,
               template: 'services/ticket.pdf.html.erb',
               background: true,
               layout: 'pdf_layout.html.erb',
               page_size: 'A4'
      end
    end
  end

  private

  def service_params
    params.require(:service).permit(:client_id, :folio, :payment_type_id,
      :date_of_entry, :discount, :departure_date, :image_client, :employee_id)
  end

  def clear_session_variables
    session[:worforce] = nil
    session[:discount] = nil
  end

end
