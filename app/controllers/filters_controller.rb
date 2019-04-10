class FiltersController < ApplicationController
  def range_date_incomes
    start_date = params[:search][:start_date]
    end_date = params[:search][:end_date]

    if start_date == "" || end_date == ""
      head :no_content
    else
      start_date = Date.strptime(start_date, '%d/%m/%Y')
      end_date = Date.strptime(end_date, '%d/%m/%Y')

      if start_date < end_date
        incomes = Payment
          .where("DATE(updated_at) >= ? AND DATE(updated_at) <= ?", start_date, end_date)

        @incomes = incomes
          .paginate(page: params[:page], per_page: self.elements_per_page)
          .order(updated_at: :desc)

        @total = Payment.total(incomes)
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

    incomes = Payment
      .where("user_id = ?", employee_id)

    @incomes = incomes
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @total = Payment.total(incomes)
    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render "incomes/search" }
    end
  end

  def client_incomes
    client_id = params[:search][:client_id]

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
            format.js { render "incomes/search" }
          end
        end

      else
        head :no_content
      end
    end
  end

  def folio_incomes
    folio = params[:search][:folio]

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
        format.js { render "incomes/search" }
      end
    end
  end
end
