class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]

  def index
    @products = Product.order(updated_at: :desc)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        flash[:success] = 'Producto creado correctamente.'
        format.html { redirect_to products_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        flash[:success] = 'Producto actualizado correctamente.'
        format.html { redirect_to products_url }
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
    @products = Product.search(params[:search]).order(created_at: :desc)
  end

  def search_sales
    begin
      discount = session[:discount_sale] || '0'
      sales_policy = SalesPolicy.new(params[:search], current_user)
      @add_product = sales_policy.add_product
      @total_sales = sales_policy.totals(discount)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:code, :name, :quantity, :price)
    end

    def fixed_format_price
        params[:product][:price] = params[:product][:price].gsub('$ ', '').gsub(',','')
    end

end
