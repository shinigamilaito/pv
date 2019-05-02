class QuotationsController < ApplicationController
  before_action :set_quotation_policy, except: [:index, :search_products]

  def index
    @quotations = Quotation
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
    end
  end

  # Interfaz realizar el registro
  # de cotizaciones
  def new
    @quotations_policy.remove_products
    @products = @quotations_policy.products
    @totals = @quotations_policy.totals
    @quotation = Quotation.new
    @module = "Cotizar"
  end

  def search_products
    begin
      quotations_policy = QuotationsPolicy.new(params[:search], current_user)
      @add_product = quotations_policy.add_product(1, true)
      @totals = quotations_policy.totals
      @quotation = Quotation.new
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar las cantidades del producto
  def update_quantity_product
    begin
      quantity = params[:quantity].to_i
      quotation_product = QuotationProduct.find(params[:quotation_product_id])
      quotations_policy = QuotationsPolicy.new(quotation_product.code, current_user)
      @add_product = quotations_policy.add_product(quantity, false)
      @totals = quotations_policy.totals
      @quotation = Quotation.new
      render 'quotations/search_products'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar el precio del producto
  def update_price_product
    quotation_product_id = params[:quotation_product_id]
    new_price = BigDecimal.new(params[:price].gsub(',', ''))
    @product = @quotations_policy.change_price_product(quotation_product_id, new_price)
    @totals = @quotations_policy.totals
    @quotation = Quotation.new
  end

  # Salvar cotización
  def create
    if params[:quotation][:client_id] == 'nil'
      render js: "toastr['error']('Cliente no valido.');", status: :bad_request
    else
      @new_quotation = Quotation.new(quotation_params)
      @new_quotation.user = current_user
      @quotations_service = QuotationsService.new(@quotations_policy, @new_quotation)

      if @quotations_service.save
        @products = @quotations_policy.products
        @totals = @quotations_policy.totals
        @quotation = Quotation.new
      else
        render js: "toastr['error']('Intente nuevamente.');", status: :bad_request
      end
    end
  end

  def get_pdf
    @quotation = Quotation.find(params[:id])

    respond_to do |format|
      format.pdf do
        @note_quotation = NoteQuotation.new(@quotation)

        render pdf: 'report',
               #wkhtmltopdf: route_wicked,
               template: 'quotations/note.pdf.html.erb',
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

  def delete_product
    quotation_product = QuotationProduct.includes(:product).find(params[:quotation_product_id])
    product = quotation_product.product
    @quotations_policy.delete(quotation_product)
    @product = quotation_product
    @totals = @quotations_policy.totals
    @quotation = Quotation.new
  end

  # Realizar la busaueda de cotizaciones por cliente
  def quotations_by_client
    @quotations = QuotationsPolicy
      .quotations_by(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

  def set_quotation_policy
    @quotations_policy = QuotationsPolicy.new(current_user)
  end

  def quotation_params
    params.require(:quotation).permit(
      :total, :client_id
    )
  end

end
