class PrintingProductsController < ApplicationController
  before_action :set_printing_product, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]
  before_action :set_module

  def index
    @printing_products = PrintingProduct
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render :search }
    end
  end

  def show
  end

  def new
    @printing_product = PrintingProduct.new
  end

  def edit
  end

  def create
    @printing_product = PrintingProduct.new(printing_product_params)

    respond_to do |format|
      if @printing_product.save
        flash[:success] = 'Producto Imprenta creado correctamente.'
        format.html { redirect_to printing_products_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @printing_product.update(printing_product_params)
        flash[:success] = 'Producto Imprenta actualizado correctamente.'
        format.html { redirect_to printing_products_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @printing_product.destroy
      respond_to do |format|
        flash[:success] = 'Producto Imprenta eliminado correctamente.'
        format.html { redirect_to printing_products_url }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      logger.debug("Failed to deleted printing product #{e}")
      flash[:error] = "El producto ya esta en uso."
      redirect_to printing_products_url
    end
  end

  # Search index
  def search
    @printing_products = PrintingProduct
      .search_index(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  # Search to add printing product sales
  def search_sales
    begin
      discount = session[:discount_printing_sale] || '0'
      printing_sales_policy = PrintingSalesPolicy.new(params[:printing_product][:id], current_user)
      @add_printing_product = printing_sales_policy.add_product(1, true)
      @total_printing_sales = printing_sales_policy.totals(discount)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def autocomplete
    @printing_products = PrintingProduct
      .search(params[:term])
      .order(created_at: :desc)
  end

  def autocomplete_invitations
    @printing_products = PrintingProduct
      .search_index(params[:term])
      .order(created_at: :desc)
  end

  def data_carousel
    @printing_products = PrintingProduct.where("product_type = ? AND imagen IS NOT NULL", params[:product_type])
    @url_background = ConfigurationData.configure.background_url
    data_carousel = render_to_string("printing_products/data_carousel", layout: false, locals: {printing_products: @printing_products})

    render json: {
        data: data_carousel
    }
  end

  private

    def set_printing_product
      @printing_product = PrintingProduct.find(params[:id])
    end

    def printing_product_params
      params.require(:printing_product).permit(
          :code, :name, :purchase_price, :purchase_unit, :content, :stock, :imagen,
          :imagen_cache, :product_type, :piece, :package, :package_stock, :box, :box_stock,
          :meter, :meter_stock, :roll, :roll_stock, :bag, :bag_stock, :set, :set_stock
      )
    end

    def fixed_format_price
        params[:printing_product][:purchase_price] = params[:printing_product][:purchase_price].gsub('$ ', '').gsub(',','')
        params[:printing_product][:piece] = params[:printing_product][:piece].gsub('$ ', '').gsub(',','')
        params[:printing_product][:package] = params[:printing_product][:package].gsub('$ ', '').gsub(',','')
        params[:printing_product][:box] = params[:printing_product][:box].gsub('$ ', '').gsub(',','')
        params[:printing_product][:meter] = params[:printing_product][:meter].gsub('$ ', '').gsub(',','')
        params[:printing_product][:roll] = params[:printing_product][:roll].gsub('$ ', '').gsub(',','')
        params[:printing_product][:bag] = params[:printing_product][:bag].gsub('$ ', '').gsub(',','')
        params[:printing_product][:set] = params[:printing_product][:set].gsub('$ ', '').gsub(',','')
    end

    def set_module
      @module = "printing_products"
    end
end
