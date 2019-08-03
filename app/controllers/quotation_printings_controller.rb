class QuotationPrintingsController < ApplicationController
  before_action :set_module
  before_action :fixed_format_price, only: [:create]

  def index
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    @clients = []
    @quotation_printings = []
    @quotation_printing = nil

    quotation_printings_policy = QuotationPrintingsPolicy.new
    quotation_printings_policy.destroy_printing_product_quotations(current_user)

    # This parameter come into after create the quotation product and
    # make an redirect to this action
    if params[:quotation_printing_created].present?
      @get_quotation_pdf = true
      @quotation_printing_created = QuotationPrinting.find(params[:quotation_printing_created])
    end
  end

  def find_quotation_printings_by_client
    quotation_printing_policy = QuotationPrintingsPolicy.new(params[:client][:id].to_i)
    @quotation_printings = quotation_printing_policy.find_quotation_printings[:quotation_printings_present]

    quotation_printing_element = render_to_string("quotation_printings/_select_quotation_printings",
                                             layout: false)

    render json: {
        quotation_printing: quotation_printing_element
    }
  end

  def new
    if params[:number_folio] == 'Nueva Cotización'
      @quotation_printing = QuotationPrinting.new
      @quotation_printing.client_id = params[:client_id]
      @invitations = []
      @invitation_id = nil
    else
      @quotation_printing = QuotationPrinting.find_by_number_folio(params[:number_folio])
      @invitation_id = @quotation_printing.invitation_id
      @invitations = [@quotation_printing.invitation.name, @invitation_id]
    end

    quotation_printing_element = render_to_string("quotation_printings/new", layout: false,
                                                  locals: { quotation_printing: @quotation_printing} )
    render json: { quotation_printing: quotation_printing_element }
  end

  # Obtiene los productos(printing_product_quotations) que han sido agregados a las cotizaciones
  def obtain_printing_products
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end

      if params[:new_invitation].present? && params[:new_invitation].eql?("true")
        @invitation = Invitation.new
        @invitation.name = params[:invitation_id]
        @invitation.user = current_user
        @invitation.created_in_quotation = true
        raise 'Error al registrar la invitación' unless @invitation.save
      else
        @invitation = Invitation.find(params[:invitation_id])
      end

      if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
        @quotation_printing_id = params[:quotation_printing_id]
      else
        @quotation_printing_id = nil
      end

      @printing_products = @invitation.invitation_printing_products
      quotation_printings_policy = QuotationPrintingsPolicy.new
      quotation_printings_policy.generate_printing_product(@invitation, current_user, @quotation_printing_id)
      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(@invitation, current_user, @quotation_printing_id)
      @total_quotation_printings = quotation_printings_policy.totals(@invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  #Obtiene los productos(printing_product_quotation) para una cotización ya creada
  def obtain_printing_products_for_quotation
    @quotation_printing = QuotationPrinting.find(params[:quotation_printing_id])
    @invitation = @quotation_printing.invitation
    @printing_products = @invitation.invitation_printing_products
    @printing_product_quotations = @quotation_printing.printing_product_quotations
    quotation_printings_policy = QuotationPrintingsPolicy.new
    @total_quotation_printings = quotation_printings_policy.totals_by_quotation(@quotation_printing)
  end

  # Actualizar las cantidades del producto
  def update_quantity_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      quantity = params[:quantity].to_i
      invitation = Invitation.find(params[:invitation_id])
      printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotation = quotation_printings_policy.update_quantity(printing_product_quotation, quantity)

      if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
        @quotation_printing_id = params[:quotation_printing_id]
      else
        @quotation_printing_id = nil
      end

      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
      render 'quotation_printings/update_quantity'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar el precio en total del producto
  def update_price_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      new_price = BigDecimal.new(params[:price].gsub(',', ''))
      invitation = Invitation.find(params[:invitation_id])
      printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotation = quotation_printings_policy.change_price_product(printing_product_quotation, new_price)

      if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
        @quotation_printing_id = params[:quotation_printing_id]
      else
        @quotation_printing_id = nil
      end

      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
      render 'quotation_printings/update_quantity'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar el precio en unidad del producto
  def update_real_price_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      real_price = BigDecimal.new(params[:real_price].gsub(',', ''))
      invitation = Invitation.find(params[:invitation_id])
      printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotation = quotation_printings_policy.change_real_price_product(printing_product_quotation, real_price)

      if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
        @quotation_printing_id = params[:quotation_printing_id]
      else
        @quotation_printing_id = nil
      end

      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
      render 'quotation_printings/update_quantity'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Obtiene el costo total después de un cambio en el costo de Elaboración
  def obtain_total_costs
    manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
    if params[:amount_to_elaborate] == ""
      amount_to_elaborate = 0
    else
      amount_to_elaborate = params[:amount_to_elaborate].to_i
    end
    invitation = Invitation.find(params[:invitation_id])

    if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
      @quotation_printing_id = params[:quotation_printing_id]
    else
      @quotation_printing_id = nil
    end

    quotation_printings_policy = QuotationPrintingsPolicy.new
    @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
  end

  def create
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    PgLock.new(name: "quotation_printings_create").lock do
      @quotation_printing = QuotationPrinting.new(quoation_printing_params)
      @quotation_printing.user = current_user
      @quotation_printing.full_payment = @quotation_printing.difference <= BigDecimal.new("0")
      @quotation_printing.number_folio = @quotation_printing.set_number_folio
      @quotation_printing.ticket = @quotation_printing.set_number_ticket
      @quotation_printing.cash_opening_impression = CashPolicy.new.cash_impressions
      quotation_printings_policy = QuotationPrintingsPolicy.new()
      printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(@quotation_printing.invitation, current_user)
      @quotation_printing.printing_product_quotations = printing_product_quotations

      if params[:quotation_printing][:imagen].blank? || params[:quotation_printing][:imagen].eql?("")
        if @quotation_printing.imagen.nil?
          @quotation_printing.imagen = @quotation_printing.invitation.imagen
        end
      end

      if @quotation_printing.save
        flash[:success] = 'Cotización para productos imprenta, registrada correctamente.'
        redirect_to quotation_printings_path(quotation_printing_created: @quotation_printing.id)
      else
        flash[:error] = 'Se presento un error al registrar la cotización. Intente mas tarde.'
        redirect_to quotation_printings_path
      end
    end
  end

  def update
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    PgLock.new(name: "quotation_printings_update").lock do
      @quotation_printing = QuotationPrinting.find(params[:id])
      @quotation_printing.user = current_user

      if params[:quotation_printing][:imagen].blank? || params[:quotation_printing][:imagen].eql?("")
        if @quotation_printing.imagen.nil?
          @quotation_printing.imagen = @quotation_printing.invitation.imagen
        end
      end

      if @quotation_printing.update(quoation_printing_params)
        flash[:success] = 'Cotización para productos imprenta, actualizada correctamente.'
        redirect_to quotation_printings_path(quotation_printing_created: @quotation_printing.id)
      else
        flash[:error] = 'Se presento un error al actualizar la cotización. Intente mas tarde.'
        redirect_to quotation_printings_path
      end
    end
  end

  def add_printing_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      @invitation = Invitation.find(params[:invitation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      printing_product = PrintingProduct.find(params[:printing_product][:id])

      if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
        @quotation_printing_id = params[:quotation_printing_id]
      else
        @quotation_printing_id = nil
      end

      quotation_printings_policy.add(current_user, @invitation, printing_product, @quotation_printing_id)
      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(@invitation, current_user, @quotation_printing_id)
      @total_quotation_printings = quotation_printings_policy.totals(@invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
      render "obtain_printing_products"
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def delete_printing_product_quotation
    manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
    if params[:amount_to_elaborate] == ""
      amount_to_elaborate = 0
    else
      amount_to_elaborate = params[:amount_to_elaborate].to_i
    end
    @invitation = Invitation.find(params[:invitation_id])
    printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])

    if params[:quotation_printing_id].present? && params[:quotation_printing_id] != ""
      @quotation_printing_id = params[:quotation_printing_id]
    else
      @quotation_printing_id = nil
    end

    if printing_product_quotation.destroy
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(@invitation, current_user, @quotation_printing_id)
      @total_quotation_printings = quotation_printings_policy.totals(@invitation, current_user, manufacturing_cost, amount_to_elaborate, @quotation_printing_id)
      render "obtain_printing_products"
    else
      render js: "toastr['error']('Imposible eliminar el producto imprenta de la cotización.');", status: :bad_request
    end
  end

  # Nota de la cotización
  def get_pdf
    @quotation_printing = QuotationPrinting.find(params[:id])

    respond_to do |format|
      format.pdf do
        @note_quotation_printing = NoteQuotationPrinting.new(@quotation_printing)

        render pdf: 'report',
               #wkhtmltopdf: route_wicked,
               template: 'quotation_printings/note.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               page_size: 'Letter',
               margin: {
                 left: 0,
                 right: 0,
                 top: 5,
                 bottom: 4
               }
      end
    end
  end

  def generate_ticket
    @quotation_printing = QuotationPrinting.find(params[:id])
    respond_to do |format|
      format.pdf do
        @ticket_quotation_printing = TicketQuotationPrinting.new(@quotation_printing)
        render pdf: 'report',
               #wkhtmltopdf: route_wicked,
               template: 'quotation_printings/ticket_paid.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               show_as_html: true,
               page_size: 'A8',
               margin: {
                   left: 0,
                   right: 0,
                   top: 5,
                   bottom: 4
               }
      end
    end
  end

  # Data for carousel
  def data_carousel
    category = Category.find params[:category_id]
    @subcategories = category.subcategories.order(:created_at)
    @subcategory = @subcategories.first
    data_carousel = render_to_string("quotation_printings/data_carousel", layout: false)

    render json: {
        data: data_carousel
    }
  end

  private

  def set_module
    @module = "OrdenTrabajo"
  end

  def quoation_printing_params
    params.require(:quotation_printing).permit(:invitation_id, :client_id, :cost_piece,
      :total_pieces, :cost_elaboration, :total_quotations, :total_cost, :utility,
      :status, :paid_with, :payment, :change, :difference, :payment_type_id, :full_payment,
      :imagen, :imagen_cache
    )
  end

  def fixed_format_price
      params[:quotation_printing][:paid_with] = params[:quotation_printing][:paid_with].gsub(',','')
      params[:quotation_printing][:payment] = params[:quotation_printing][:payment].gsub(',','')
      params[:quotation_printing][:change] = params[:quotation_printing][:change].gsub(',','')
  end

end
