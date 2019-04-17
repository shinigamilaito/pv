class CashesController < ApplicationController
  def new_open_cash
    open_date = DateTime.now
    employee = current_user
    amount = "0.00"
    @cash = CashOpenService.new(open_date, employee, amount)

    if @cash.types_cashes.blank?
      flash[:notice] = "Todas las cajas han sido abiertas."
      redirect_to root_path and return
    end
  end

  def open_cash
    begin
      PgLock.new(name: "cashes_open_cash").lock do
        open_date = params[:cash][:open_date].to_datetime
        employee = current_user
        amount = format_amount(params[:cash][:amount])
        type_cash = params[:cash][:type_cash]
        @cash = CashOpenService.new(open_date, employee, amount, type_cash)
        @cash.open_cash
        flash[:success] = "La caja fue correctamente abierta."
        redirect_to root_path
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

    if params[:type_cash].present?
      @cash_close_service.type_cash = params[:type_cash]
    else
      @cash_close_service.cash
    end

    if @cash_close_service.types_cashes_opened.blank?
      flash[:notice] = "Todas las cajas han sido cerradas."
      redirect_to root_path and return
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
        redirect_to root_url(cash: cash_open, type: cash_open.type_cash)
      end
    rescue StandardError => e
      flash[:error] = "#{e.message}"
      redirect_to cashes_new_close_cash_url
    end
  end

  def generate_xlsx
    if params[:type] == "servicios"
      cash = CashOpeningService.find(params[:cash])
      @incomes_xlsx = cash.payments
      @total = Payment.total(@incomes_xlsx)
      @title = "Ingresos por Servicios"
      response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
      render xlsx: @title, template: 'incomes/index'
    else
      cash = CashOpeningSale.find(params[:cash])
      @sales_xlsx = cash.sales
      @total = Sale.total(@sales_xlsx)
      @title = "Ingresos por Ventas"
      response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
      render xlsx: @title, template: 'sales/index'
    end
  end

  private

  def format_amount(amount)
    return amount.gsub("$", "").gsub(",", "")
  end
end
