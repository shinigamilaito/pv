class FiltersController < ApplicationController
  def range_date_incomes
    p params
    #search"=>{"start_date"=>"04/02/2019", "end_date"=>""}

    #byebug
    start_date = params[:search][:start_date]
    end_date = params[:search][:end_date]

    if start_date == "" || end_date == ""
      head :no_content
    else
      start_date = Date.strptime(start_date, '%d/%m/%Y')
      end_date = Date.strptime(end_date, '%d/%m/%Y')
      if start_date < end_date
        @incomes = Payment
          .where("DATE(updated_at) >= ? AND DATE(updated_at) <= ?", start_date, end_date)
          .paginate(page: params[:page], per_page: self.elements_per_page)
          .order(updated_at: :desc)

        @index = obtain_index(params[:page].to_i)

        respond_to do |format|
          format.html { render :index }
          format.js { render "incomes/search" }
        end
      else
        head :no_content
      end
    end
  end

  def employee_incomes
    employee_id = params[:search][:employee_id]

    @incomes = Payment
      .where("user_id = ?", employee_id)
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render "incomes/search" }
    end
  end

  def client_incomes
    client_id = params[:search][:client_id]

    @incomes = Payment
      .joins(:service)
      .where("services.client_id = ?", client_id)
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render "incomes/search" }
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
        @incomes = Payment
          .all
          .map { |payment| payment.cost >= lower_limit && payment.cost <= upper_limit}
          .paginate(page: params[:page], per_page: self.elements_per_page)
          .order(updated_at: :desc)

        @index = obtain_index(params[:page].to_i)

        respond_to do |format|
          format.html { render :index }
          format.js { render "incomes/search" }
        end
      else
        head :no_content
      end
    end
  end
end
