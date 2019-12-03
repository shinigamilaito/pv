class QuotationPrintingIncomeReportsController < ApplicationController
  def index
    sales = QuotationPrinting
                .all

    @total = QuotationPrinting.total(sales)
    @sales = sales
                 .paginate(page: params[:page], per_page: self.elements_per_page)
                 .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)
    @module = "incomes_quotation_printing"

    respond_to do |format|
      format.html { render :index }
      format.js { render :search }
      format.xlsx {
        @title = 'Ingresos por Ventas en Imprenta'
        @sales_xlsx = sales
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
      }
    end
  end

  def range_date_incomes
    if params[:search].present?
      start_date_string = params[:search][:start_date]
      end_date_string = params[:search][:end_date]
    else
      start_date_string = session[:start_date_string]
      end_date_string = session[:end_date_string]
    end

    if start_date_string == "" || end_date_string == ""
      head :no_content
    else
      start_date = Date.strptime(start_date_string, '%d/%m/%Y')
      end_date = Date.strptime(end_date_string, '%d/%m/%Y')

      if start_date <= end_date
        sales_ids = QuotationPrinting
                        .select do |sale|
          sale.updated_at.to_date >= start_date && sale.updated_at.to_date <= end_date
        end
                        .map(&:id)

        sales = QuotationPrinting
                    .where("id IN (?)", sales_ids)

        @sales = sales
                     .paginate(page: params[:page], per_page: self.elements_per_page)
                     .order(updated_at: :desc)

        @total = QuotationPrinting.total(sales)
        @index = obtain_index(params[:page].to_i)

        respond_to do |format|
          format.html { render :index }
          format.js {
            session[:start_date_string] = start_date_string
            session[:end_date_string] = end_date_string
            render "search"
          }
          format.xlsx {
            @sales_xlsx = sales
            @title = "Ingresos por Ordenes de Trabajo: #{start_date} - #{end_date}"
            response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
            render xlsx: @title, template: 'quotation_printing_income_reports/index'
          }
        end
      else
        head :no_content
      end
    end
  end

  def employee_incomes
    if params["search"].present?
      employee_id = params[:search][:employee_id]
    else
      employee_id = session[:employee_id]
    end

    sales = QuotationPrinting
                .where("user_id = ?", employee_id)

    @sales = sales
                 .paginate(page: params[:page], per_page: self.elements_per_page)
                 .order(updated_at: :desc)

    @total = QuotationPrinting.total(sales)
    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js {
        session[:employee_id] = employee_id
        render "search"
      }
      format.xlsx {
        name_employee = User.find(employee_id).formal_name
        @title = "Ingresos por Ordenes de Trabajo - Empleado: #{name_employee}"
        @sales_xlsx = sales
        response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
        render xlsx: @title, template: 'quotation_printing_income_reports/index'
      }
    end
  end

  def range_quantity_incomes
    if params[:search].present?
      lower_limit_string = params[:search][:lower_limit]
      upper_limit_string = params[:search][:upper_limit]
    else
      lower_limit_string = session[:lower_limit_string]
      upper_limit_string = session[:upper_limit_string]
    end

    if lower_limit_string == "" || upper_limit_string == ""
      head :no_content
    else
      lower_limit = BigDecimal.new(lower_limit_string, 2)
      upper_limit = BigDecimal.new(upper_limit_string,2)

      if lower_limit < upper_limit
        sales = QuotationPrinting
                    .where("payment >= ? AND payment <= ?", lower_limit, upper_limit)

        @sales = sales
                     .paginate(page: params[:page], per_page: self.elements_per_page)
                     .order(updated_at: :desc)

        @total = QuotationPrinting.total(sales)
        @index = obtain_index(params[:page].to_i)

        respond_to do |format|
          format.html { render :index }
          format.js {
            session[:lower_limit_string] = lower_limit_string
            session[:upper_limit_string] = upper_limit_string
            render "search"
          }
          format.xlsx {
            lower_quantity = ActionController::Base.helpers.number_to_currency lower_limit_string
            upper_quantity = ActionController::Base.helpers.number_to_currency upper_limit_string
            @title = "Ingresos por Ordenes de Trabajo: #{lower_quantity} - #{upper_quantity}"
            @sales_xlsx = sales
            response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
            render xlsx: @title, template: 'quotation_printing_income_reports/index'
          }
        end

      else
        head :no_content
      end
    end
  end

  def ticket_incomes
    if params[:search].present?
      ticket = params[:search][:ticket]
    else
      ticket = session[:ticket]
    end

    if ticket == ""
      head :no_content
    else
      sales = QuotationPrinting
                  .where("number_folio = ?", ticket)

      @sales = sales
                   .paginate(page: params[:page], per_page: self.elements_per_page)
                   .order(updated_at: :desc)

      @total = QuotationPrinting.total(sales)
      @index = obtain_index(params[:page].to_i)

      respond_to do |format|
        format.html { render :index }
        format.js {
          session[:ticket] = ticket
          render "search"
        }
        format.xlsx {
          @title = "Ingresos por Ordenes de Trabajo - Folio: #{ticket}"
          @sales_xlsx = sales
          response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
          render xlsx: @title, template: 'quotation_printing_income_reports/index'
        }
      end
    end
  end
end
