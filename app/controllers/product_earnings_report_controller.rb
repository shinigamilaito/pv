class ProductEarningsReportController < ApplicationController
  def index
    report_service = ProductEarningReportService.new(params_search).result

    @sales = report_service[:sales]
                 .paginate(page: params[:page], per_page: self.elements_per_page)
                 .order(updated_at: :desc)
    @total = report_service[:total]
    @index = obtain_index(params[:page].to_i)
    @module = "product_earnings_report"
    @title = "Reporte de Ganancias"

    respond_to do |format|
      format.html { render :index }
      format.js {}
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="#{@title}.xlsx"'
        render xlsx: @title, template: 'product_earnings_report/index'
      }
    end
  end

  private

  def params_search
    if params[:search].present?
      return params[:search]
    else
      return default_params
    end
  end

  def default_params
    @start_date = Date.today.strftime("%d/%m/%Y")
    return {
        type: "date",
        start_date: @start_date,
        end_date: @start_date,
        source: "Sale"
    }
  end
end
