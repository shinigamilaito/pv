class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_sale_policy, only: [:index, :delete_product]

  def index
    @products_in_sale = @sales_policy.products_for_sale
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

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
      else
        format.html { render :new }
      end
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
    sale_product = SaleProduct.includes(:product).find(params[:sale_product_id])
    product = sale_product.product
    @sales_policy.delete(sale_product, product)
    @product = sale_product
  end

  private

    def set_sale
      @sale = Sale.find(params[:id])
    end

    def sale_params
      params.require(:sale).permit(:user_id)
    end

    def set_sale_policy
      @sales_policy = SalesPolicy.new(current_user)
    end
end
