class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_sale_policy, only: [:index, :delete_product, :update_discount, :create]

  def index
    clear_variables
    discount = session[:discount_sale] || '0'
    @products_in_sale = @sales_policy.products_for_sale
    @total_sales = @sales_policy.totals(discount)
  end

  def show
  end

  def new
    @sale = Sale.new
  end

  def edit
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.user = current_user
    @sales_service = SalesService.new(@sales_policy, @sale)

    if @sales_service.save
      clear_variables
      @products_in_sale = @sales_policy.products_for_sale
      @total_sales = @sales_policy.totals
    else
      render js: "toastr['error']('Intente nuevamente.');", status: :bad_request
    end
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_product
    discount = session[:discount_sale] || '0'
    sale_product = SaleProduct.includes(:product).find(params[:sale_product_id])
    product = sale_product.product
    @sales_policy.delete(sale_product, product)
    @product = sale_product
    @total_sales = @sales_policy.totals(discount)
  end

  def update_discount
    session[:discount_sale] = BigDecimal.new(params[:discount].gsub(',',''))

    if current_user.sale_products.present?
      @total_sales = @sales_policy.totals(session[:discount_sale])
    else
      head :ok
    end
  end

  def preview
    paid_with = params[:paid_with].gsub(',','')
    change = params[:change].gsub(',','')
    discount = params[:discount]
    payment_type = PaymentType.find(params[:payment_type_id])
    @ticket_sale = TicketSale.new(current_user, paid_with, change, discount, payment_type)
    @sale = Sale.new
    @sale.payment_type = payment_type
  end

  private

    def set_sale
      @sale = Sale.find(params[:id])
    end

    def sale_params
      params.require(:sale).permit(
        :subtotal, :discount, :total, :paid_with, :change, :payment_type_id
      )
    end

    def set_sale_policy
      @sales_policy = SalesPolicy.new(current_user)
    end

    def clear_variables
      session[:discount_sale] = nil
    end
end
