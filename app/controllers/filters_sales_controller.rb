class FiltersSalesController < ApplicationController
  def range_date_incomes
    start_date = params[:search][:start_date]
    end_date = params[:search][:end_date]

    if start_date == "" || end_date == ""
      head :no_content
    else
      start_date = Date.strptime(start_date, '%d/%m/%Y')
      end_date = Date.strptime(end_date, '%d/%m/%Y')

      if start_date < end_date
        sales = Sale
          .where("DATE(updated_at) >= ? AND DATE(updated_at) <= ?", start_date, end_date)

        @sales = sales
          .paginate(page: params[:page], per_page: self.elements_per_page)
          .order(updated_at: :desc)

        @total = Sale.total(sales)
        @index = obtain_index(params[:page].to_i)

        respond_to do |format|
          format.html { render :index }
          format.js { render "sales/search" }
        end
      else
        head :no_content
      end
    end
  end

  def employee_incomes
    employee_id = params[:search][:employee_id]

    sales = Sale
      .where("user_id = ?", employee_id)

    @sales = sales
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @total = Sale.total(sales)
    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render "sales/search" }
    end
  end

  def range_quantity_incomes
    lower_limit = params[:search][:lower_limit]
    upper_limit = params[:search][:upper_limit]

    if lower_limit == "" || upper_limit == ""
      head :no_content
    else
      lower_limit = BigDecimal.new(lower_limit)
      upper_limit = BigDecimal.new(upper_limit)

      if lower_limit < upper_limit
        sales = Sale
          .where("total >= ? AND total <= ?", lower_limit, upper_limit)

          @sales = sales
            .paginate(page: params[:page], per_page: self.elements_per_page)
            .order(updated_at: :desc)

          @total = Sale.total(sales)
          @index = obtain_index(params[:page].to_i)

          respond_to do |format|
            format.html { render :index }
            format.js { render "sales/search" }
          end

      else
        head :no_content
      end
    end
  end

  def ticket_incomes
    ticket = params[:search][:ticket]

    if ticket == ""
      head :no_content
    else
      sales = Sale
        .where("ticket = ?", ticket)

      @sales = sales
        .paginate(page: params[:page], per_page: self.elements_per_page)
        .order(updated_at: :desc)

      @total = Sale.total(sales)
      @index = obtain_index(params[:page].to_i)

      respond_to do |format|
        format.html { render :index }
        format.js { render "sales/search" }
      end
    end
  end
end
