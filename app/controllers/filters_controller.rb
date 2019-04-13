class FiltersController < ApplicationController
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
        incomes_ids = Payment
          .select do |payment|
            payment.updated_at.to_date >= start_date && payment.updated_at.to_date <= end_date
          end
          .map(&:id)

        incomes = Payment
          .where("id IN (?)", incomes_ids)

        @incomes = incomes
          .paginate(page: params[:page], per_page: self.elements_per_page)
          .order(updated_at: :desc)

        @total = Payment.total(incomes)
        @index = obtain_index(params[:page].to_i)

        respond_to do |format|
          format.html { render :index }
          format.js {
            session[:start_date_string] = start_date_string
            session[:end_date_string] = end_date_string
            render "incomes/search"
          }
          format.xlsx {
            @title = "Ingresos por Servicios: #{start_date} - #{end_date}"
            @incomes_xlsx = incomes
            response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
            render xlsx: @title, template: 'incomes/index'
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

    incomes = Payment
      .where("user_id = ?", employee_id)

    @incomes = incomes
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @total = Payment.total(incomes)
    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js {
        session[:employee_id] = employee_id
        render "incomes/search"
      }
      format.xlsx {
        name_employee = User.find(employee_id).formal_name
        @title = "Ingresos por Servicio - Empleado: #{name_employee}"
        @incomes_xlsx = incomes
        response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
        render xlsx: @title, template: 'incomes/index'
      }
    end
  end

  def client_incomes
    if params[:search].present?
      client_id = params[:search][:client_id]
    else
      client_id = session[:client_id]
    end

    incomes = Payment
      .joins(:service)
      .where("services.client_id = ?", client_id)

    @incomes = incomes
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @total = Payment.total(incomes)
    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js {
        session[:client_id] = client_id
        render "incomes/search"
      }
      format.xlsx {
        name_client = Client.find(client_id).formal_name
        @title = "Ingresos por Servicios - Cliente: #{name_client}"
        @incomes_xlsx = incomes
        response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
        render xlsx: @title, template: 'incomes/index'
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
      lower_limit = BigDecimal.new(lower_limit_string)
      upper_limit = BigDecimal.new(upper_limit_string)

      if lower_limit < upper_limit
        incomes_ids = Payment
          .select { |payment| payment.cost >= lower_limit && payment.cost <= upper_limit}
          .map(&:id)

        if incomes_ids.blank?
          head :no_content
        else
          incomes = Payment
            .where("id IN (?)", incomes_ids)

          @incomes = incomes
            .paginate(page: params[:page], per_page: self.elements_per_page)
            .order(updated_at: :desc)

          @total = Payment.total(incomes)
          @index = obtain_index(params[:page].to_i)

          respond_to do |format|
            format.html { render :index }
            format.js {
              session[:lower_limit_string] = lower_limit_string
              session[:upper_limit_string] = upper_limit_string
              render "incomes/search"
            }
            format.xlsx {
              lower_quantity = ActionController::Base.helpers.number_to_currency lower_limit_string
              upper_quantity = ActionController::Base.helpers.number_to_currency upper_limit_string
              @title = "Ingresos por Servicios: #{lower_quantity} - #{upper_quantity}"
              @incomes_xlsx = incomes
              response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
              render xlsx: @title, template: 'incomes/index'
            }
          end
        end

      else
        head :no_content
      end
    end
  end

  def folio_incomes
    if params[:search].present?
      folio = params[:search][:folio]
    else
      folio = session[:folio]
    end

    if folio == ""
      head :no_content
    else
      incomes = Payment
        .joins(:service)
        .where("number_folio = ?", folio)

      @incomes = incomes
        .paginate(page: params[:page], per_page: self.elements_per_page)
        .order(updated_at: :desc)

      @total = Payment.total(incomes)
      @index = obtain_index(params[:page].to_i)

      respond_to do |format|
        format.html { render :index }
        format.js {
          session[:folio] = folio
          render "incomes/search"
        }
        format.xlsx {
          @title = "Ingresos por Servicios - Folio: #{folio}"
          @incomes_xlsx = incomes
          response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
          render xlsx: @title, template: 'incomes/index'
        }
      end
    end
  end
end
