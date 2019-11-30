class ProductEarningReportService
  attr_reader :params_search

  def initialize(params_search)
    @params_search = params_search
  end

  def result
    case params_search[:type]
    when "date"
        earning_by_date
    when "employee"
        earning_by_employee
    else
      Sale.none
    end
  end

  private

  def earning_by_date
    start_date_string = params_search[:start_date]
    end_date_string = params_search[:end_date]
    source = params_search[:source].constantize

    if start_date_string == "" || end_date_string == ""
      empty_result
    else
      start_date = Date.strptime(start_date_string, '%d/%m/%Y')
      end_date = Date.strptime(end_date_string, '%d/%m/%Y')

      if start_date <= end_date
        sales = source.where(updated_at: start_date..end_date)
        { sales: sales, total: source.earnings_by_product(sales) }
      else
        empty_result
      end
    end
  end

  def earning_by_employee
    start_date_string = params_search[:start_date]
    end_date_string = params_search[:end_date]
    source = params_search[:source].constantize


    if start_date_string == "" || end_date_string == ""
      sales_by_employee = source.where(user_id: params_search[:employee_id])
    else
      sales_by_employee = earning_by_date[:sales].where(user_id: params_search[:employee_id])
    end

    { sales: sales_by_employee, total: source.earnings_by_product(sales_by_employee) }
  end

  def empty_result
    { sales: Sale.none, total: BigDecimal.new(0, 2) }
  end
end