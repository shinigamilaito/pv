class CashesController < ApplicationController
    before_action :fixed_format_amount, only: [:create_movement]

  # Vista para mostrar formulario
  # de aperturas de cajas
  def new_open_cash
    open_date = DateTime.now
    employee = current_user
    amount = "0.00"
    @cash = CashOpenService.new(open_date, employee, amount)
    @module = "open_cashes"

    if @cash.types_cashes.blank?
      flash[:notice] = "Todas las cajas han sido abiertas."
      redirect_to root_url and return
    end
  end

  # Realizar apertura de caja
  def open_cash
    begin
      PgLock.new(name: "cashes_open_cash").lock do
        open_date = params[:cash][:open_date].to_datetime
        employee = current_user
        amount = format_amount(params[:cash][:amount])
        type_cash = params[:cash][:type_cash]
        @cash = CashOpenService.new(open_date, employee, amount, type_cash)
        cash_open = @cash.open_cash
        flash[:success] = "La caja fue correctamente abierta."
        redirect_to root_url(cash: cash_open, type: cash_open.type_cash, method_name: 'open_cash')
      end
    rescue StandardError => e
      flash[:error] = "#{e.message}"
      redirect_to cashes_new_open_cash_url
    end
  end

  def new_close_cash
    close_date = DateTime.now
    employee = current_user
    @cash_close_service = CashCloseService.new(close_date, employee)
    @module = "close_cashes"

    if params[:type_cash].present?
      @cash_close_service.type_cash = params[:type_cash]
    else
      @cash_close_service.cash
    end

    if @cash_close_service.types_cashes_opened.blank?
      flash[:notice] = "Todas las cajas han sido cerradas."
      redirect_to root_url and return
    end
  end

  def close_cash
    begin
      PgLock.new(name: "cashes_close_cash").lock do
        close_date = params[:cash][:close_date].to_datetime
        employee = current_user
        type_cash = params[:cash][:type_cash]
        @cash = CashCloseService.new(close_date, employee)
        @cash.type_cash = type_cash
        cash_open = @cash.cash
        @cash.close_cash
        flash[:success] = "La caja fue correctamente cerrada."
        redirect_to root_url(cash: cash_open, type: cash_open.type_cash, method_name: 'close_cash')
      end
    rescue StandardError => e
      flash[:error] = "#{e.message}"
      redirect_to cashes_new_close_cash_url
    end
  end

  def generate_xlsx
    if params[:type] == "services_sales"
      cash = CashOpeningServicesSale.find(params[:cash])
      cash_policy = CashPolicy.new
      @incomes_xlsx = cash_policy.incomes(cash)
      @total = cash_policy.totals(cash)
      @title = "Ingresos por Servicios y Ventas"
      response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
      render xlsx: @title, template: 'cashes/services_sales'
    else
      cash = CashOpeningSale.find(params[:cash])
      @sales_xlsx = cash.sales
      @total = Sale.total(@sales_xlsx)
      @title = "Ingresos por Ventas"
      response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
      render xlsx: @title, template: 'sales/index'
    end
  end

  def ticket_open_cash
    if params[:type] == "services_sales"
      @cash = CashOpeningServicesSale.find(params[:cash])
      @title = "Ingresos por Servicios y Ventas"
      @sucursal = "Accesorios y Servicios"
    else
      # Cambiar por caja de impresiones
      @cash = CashOpeningImpression.find(params[:cash])
      @title = "Ingresos por Ventas"
      @sucursal = "Accesorios"
    end
    respond_to do |format|
      format.pdf do

        render pdf: 'report',
               wkhtmltopdf: route_wicked,
               template: 'cashes/ticket_open_cash.pdf.html.erb',
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

  # Form to register movement in cash
  def new_movement
    redirect_to root_url and return
    
    @cash_movement = CashMovement.new
    close_date = DateTime.now
    employee = current_user
    @cash = CashCloseService.new(close_date, employee)
    @type_movements = ["Entrada", "Salida"]
    @reasons = ["Abono a cuenta", "Otro"]
    @module = "movements_cash"

    if @cash.types_cashes_opened.blank?
      flash[:warning] = "Todas las cajas estan cerradas"
      redirect_to root_url and return
    end
  end

  # Save record movement in cash
  def create_movement
    @cash_movement = CashMovement.new(cash_movement_params)
    @cash_movement.user = current_user
    type_cash = params[:type_cash]

    if type_cash == "services_sales"
      cash_services_sales = CashPolicy.new.cash_services_sales
      @cash_movement.cash = cash_services_sales
    end

    if @cash_movement.type_movement == 'Salida'
      @cash_movement.payment_type_id = 1 #Efectivo
    end

    respond_to do |format|
      if @cash_movement.save
        flash[:success] = 'Movimiento registrado correctamente.'
        format.html { redirect_to root_url }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { redirect_to cashes_new_movement_url }
      end
    end
  end

  private
  def fixed_format_amount
      params[:cash_movement][:amount] = params[:cash_movement][:amount].gsub('$', '').gsub(',','')
  end

  def format_amount(amount)
    return amount.gsub("$", "").gsub(",", "")
  end

  def cash_movement_params
    params.require(:cash_movement).permit(:cash, :amount, :type_movement, :reason, :payment_type_id, :comments)
  end
end
