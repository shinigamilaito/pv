class QuotationPrintingsController < ApplicationController
  before_action :set_module
  before_action :fixed_format_price, only: [:create, :update]

  def index
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    if params[:quotation_printing_id].present?
      @clients = Client.all
      @quotation_printing = QuotationPrinting.find(params[:quotation_printing_id])
      @client = @quotation_printing.client
      quotation_printing_policy = QuotationPrintingsPolicy.new(@quotation_printing.client_id)
      @quotation_printings = quotation_printing_policy.find_quotation_printings[:quotation_printings_present]
      @number_folio = quotation_printing_policy.quotation_printings_with_date_creation(@quotation_printing)
    else
      @clients = []
      @quotation_printings = []
      @quotation_printing = nil
      @client = nil
    end

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
    else
      @quotation_printing = QuotationPrinting.find_by_number_folio(params[:number_folio])
    end

    quotation_printing_element = render_to_string("quotation_printings/new", layout: false,
                                                  locals: {quotation_printing: @quotation_printing})
    render json: {quotation_printing: quotation_printing_element}
  end

  def create
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    @quotation_printing = QuotationPrinting.new(quotation_printing_params)
    @quotation_printing.user = current_user

    if @quotation_printing.message_history_quotation_printings.first.present?
      @quotation_printing.message_history_quotation_printings.first.user = current_user
    end

    if @quotation_printing.save
      flash[:success] = 'Cotización para productos imprenta, registrada correctamente.'
      redirect_to quotation_printings_path(quotation_printing_created: @quotation_printing.id)
    else
      flash[:error] = 'Se presento un error al registrar la cotización. Intente mas tarde.'
      redirect_to quotation_printings_path
    end
  end

  def update
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    @quotation_printing = QuotationPrinting.find(params[:id])
    @quotation_printing.user = current_user
    #@quotation_printing.message_history_quotation_printings.first.user = current_user

    if @quotation_printing.update(quotation_printing_params)
      flash[:success] = 'Cotización para productos imprenta, actualizada correctamente.'
      redirect_to quotation_printings_path(quotation_printing_created: @quotation_printing.id)
    else
      flash[:error] = 'Se presento un error al actualizar la cotización. Intente mas tarde.'
      redirect_to quotation_printings_path
    end

=begin
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
=end
  end

  # Nota de la cotización
  def get_pdf
    @quotation_printing = QuotationPrinting.find(params[:id])

    respond_to do |format|
      format.pdf do
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

=begin
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
=end

  # Data for carousel
  def data_carousel
    @url_background = ConfigurationData.configure.background_url

    if params[:category_id].present?
      category = Category.find params[:category_id]
      @subcategories = category.subcategories.order(:created_at)
      @subcategory = @subcategories.first
      @type = params[:type]
      data_carousel = render_to_string("quotation_printings/data_carousel", layout: false)
    end

    if params[:subcategory_id].present?
      @subcategory = Subcategory.find(params[:subcategory_id])
      @type = params[:type]
      @search = params[:search]
      data_carousel = render_to_string("quotation_printings/_images_carousel", layout: false, locals: {subcategory: @subcategory})
    end

    render json: {
        data: data_carousel
    }
  end

  def add_history
    quotation_printing = QuotationPrinting.find params[:id]
    message_history = MessageHistoryQuotationPrinting.new({message: params[:message], user_id: current_user.id})
    quotation_printing.message_history_quotation_printings << message_history
    quotation_printing.save

    render json: {
        result: render_to_string("message_history_quotation_printings/_message_history_quotation_printing",
                                 layout: false, locals: {message_history_quotation_printing: message_history})
    }
  end

  # Pending quotations
  def all
    @quotation_printings = QuotationPrinting
                               .all
                               .paginate(page: params[:page], per_page: self.elements_per_page)
                               .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)
    @module = "quotation_printings"

    respond_to do |format|
      format.html {render :quotations}
      format.js {render :quotations_by_client}
    end
  end

  def all_by_client
    @quotation_printings = QuotationPrinting
                            .all_by_client(params[:search])
                            .paginate(page: params[:page], per_page: self.elements_per_page)
                            .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  def cancel
    @quotation_printing = QuotationPrinting.find(params[:id])
    @quotation_printing.status = "canceled"
    @quotation_printing.save
  end

  private

  def set_module
    @module = "quotation_printing"
  end

  def quotation_printing_params
    params.require(:quotation_printing).permit([:client_id, :invitation_id,
                                                :content_for_invitation_id, :draft_delivery_date, :delivery_date, :total_pieces, :printing_type,
                                                :description, :description_adjust_design, :message, :total_cost, :payment, :difference,
                                                product_types: [:printing_product_id, :quantity]
                                               ])
  end

  def fixed_format_price
    params[:quotation_printing][:total_cost] = params[:quotation_printing][:total_cost].gsub("$ ", "").gsub(',', '')
    params[:quotation_printing][:payment] = params[:quotation_printing][:payment].gsub("$ ", "").gsub(',', '')
    params[:quotation_printing][:difference] = params[:quotation_printing][:difference].gsub("$ ", "").gsub(',', '')
  end

end
