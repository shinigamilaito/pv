class PrintingProductsController < ApplicationController
  before_action :set_printing_product, only: [:show, :edit, :update, :destroy, :translate]
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
        @printing_product.imagen = printing_product_params[:imagen]
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
      @product.destroy
      respond_to do |format|
        flash[:success] = 'Producto eliminado correctamente.'
        format.html { redirect_to products_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = "El producto ya esta en uso."
      redirect_to products_url
    end
  end

  def search
    @products = Product
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  def search_sales
    begin
      discount = session[:discount_sale] || '0'
      sales_policy = SalesPolicy.new(params[:search], current_user)
      @add_product = sales_policy.add_product(1, true)
      @total_sales = sales_policy.totals(discount)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def translate
    begin
      translate_items = TranslateItems.new
      translate_items.translate_products_to_spare_parts(@product)
      flash[:notice] = 'Traspaso exitoso.'
      redirect_to products_url and return
    rescue StandardError => e
      flash[:error] = "#{e.message}"
      redirect_to products_url and return
    end
  end

  private

    def set_printing_product
      @printing_product = PrintingProduct.find(params[:id])
    end

    def printing_product_params
      params.require(:printing_product).permit(
        :code, :name, :purchase_price, :sale_price, :sale_unit, :stock, :contains,
        :contain_unit, :imagen, :imagen_cache)
    end

    def fixed_format_price
        params[:printing_product][:purchase_price] = params[:printing_product][:purchase_price].gsub('$ ', '').gsub(',','')
        params[:printing_product][:sale_price] = params[:printing_product][:sale_price].gsub('$ ', '').gsub(',','')
    end

    def set_module
      @module = "printing_products"
    end

end
