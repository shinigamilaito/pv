class PrintingSalesController < ApplicationController
  before_action :set_printing_sale_policy, except: [:index, :delete_product]

  def index
    sales = Sale.all

    @total = Sale.total(sales)
    @sales = sales
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)
    @module = "incomes_sales"

    respond_to do |format|
      format.html { render :index }
      format.js { render :search }
      format.xlsx {
        @title = 'Ingresos por Ventas'
        @sales_xlsx = sales
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
      }
    end
  end

  # Add products printing to sales
  def new
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    clear_variables
    discount = session[:discount_printing_sale] || '0'
    @printing_sales_policy.remove_products_in_sale
    @printing_products_in_sale = @printing_sales_policy.products_for_sale
    @total_printing_sales = @printing_sales_policy.totals(discount)
    @module = "VentasImpresiones"
  end

  # Create record of the sale
  def create
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    @printing_sale = PrintingSale.new(printing_sale_params)
    @printing_sale.user = current_user
    @printing_sales_service = PrintingSalesService.new(@printing_sales_policy, @printing_sale)

    if @printing_sales_service.save
      clear_variables
      @printing_products_in_sale = @printing_sales_policy.products_for_sale
      @total_printing_sales = @printing_sales_policy.totals
    else
      render js: "toastr['error']('Intente nuevamente.');", status: :bad_request
    end
  end

  def delete_product
    discount = session[:discount_printing_sale] || '0'
    printing_sale_product = PrintingSaleProduct.includes(:printing_product).find(params[:printing_sale_product_id])
    printing_product = printing_sale_product.printing_product
    @printing_sales_policy = PrintingSalesPolicy.new(printing_product.id, current_user)
    @printing_sales_policy.delete(printing_sale_product, printing_product)
    @printing_sale_product = printing_sale_product
    @total_printing_sales = @printing_sales_policy.totals(discount)
  end

  # Actualizar el descuento de la venta
  def update_discount
    session[:discount_sale] = BigDecimal.new(params[:discount].gsub(',',''), 2)

    if current_user.sale_products.present?
      @total_sales = @sales_policy.totals(session[:discount_sale])
    else
      head :ok
    end
  end

  # Actualizar las cantidades del producto
  def update_quantity_product
    begin
      discount = session[:discount_printing_sale] || '0'
      quantity = params[:quantity].to_i
      printing_sale_product = PrintingSaleProduct.find(params[:printing_sale_printing_product_id])
      printing_sales_policy = PrintingSalesPolicy.new(printing_sale_product.printing_product_id, current_user)
      @add_printing_product = printing_sales_policy.add_product(quantity, false)
      @total_printing_sales = printing_sales_policy.totals(discount)
      render 'printing_products/search_sales'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar el precio en total del producto
  def update_price_product
    printing_sale_product_id = params[:printing_sale_printing_product_id]
    new_price = BigDecimal.new(params[:price].gsub(',', ''), 2)
    discount_sale_percentage = session[:discount_printing_sale] || BigDecimal.new('0', 2)
    @printing_sale_product = @printing_sales_policy.change_price_product(printing_sale_product_id, new_price)
    @total_printing_sales = @printing_sales_policy.totals(discount_sale_percentage)
  end

  # Actualizar el precio en unidad del producto
  def update_real_price_product
    printing_sale_product_id = params[:printing_sale_product_id]
    new_price = BigDecimal.new(params[:real_price].gsub(',', ''), 2)
    discount_sale_percentage = session[:discount_printing_sale] || BigDecimal.new('0',2)
    @printing_sale_product = @printing_sales_policy.change_real_price_product(printing_sale_product_id, new_price)
    @total_printing_sales = @printing_sales_policy.totals(discount_sale_percentage)

    render 'printing_sales/update_price_product'
  end

  # Buscar productos para ventas de impresiones
  def search_sales
    @printing_products = PrintingProduct.search_index(params[:term]).order(created_at: :desc)
  end

  # Changed sale unit
  # {"key_unit"=>"box", "value_unit"=>"Caja", "printing_sale_product_id"=>"103", "quantity"=>"1"}
  def update_sale_unit
    printing_sale_product = PrintingSaleProduct.find params[:printing_sale_product_id]
    printing_sales_policy = PrintingSalesPolicy.new(printing_sale_product.printing_product.id, current_user)

    #Check availability stock
    printing_product = printing_sale_product.printing_product
    if printing_product.purchase_unit.eql?(params[:value_unit])
      quantity_to_decrease = printing_product.content * params[:quantity].to_i
    else
      quantity_to_decrease = printing_product.send("#{params[:key_unit]}_stock") * params[:quantity].to_i
    end

    if printing_product.stock < quantity_to_decrease
      head :bad_request
    else
      if printing_sale_product.sale_unit.present?
        # Return quantity product to stock
        printing_sales_policy.adjust_quantity_product(printing_sale_product.quantity)
      end

      if printing_sale_product.update_fields_to(
          key_sale: params[:key_unit].to_s, value_sale: params[:value_unit], quantity: params[:quantity].to_i)

        if printing_sales_policy.decrement_total_product(printing_sale_product.quantity)
          render json: printing_sale_product
        else
          head :bad_requests
        end

      else
        head :bad_requests
      end
    end
  end

  private

    def printing_sale_params
      params.permit(:paid_with, :change, :payment_type_id, :client_id, :total_paid,
        :difference, :full_payment, :payment)
    end

    def set_printing_sale_policy
      @printing_sales_policy = PrintingSalesPolicy.new(current_user)
    end

    def clear_variables
      session[:discount_printing_sale] = nil
    end
end
