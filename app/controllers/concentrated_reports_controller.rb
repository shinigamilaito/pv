class ConcentratedReportsController < ApplicationController
  def sales
    initialize_variables("sales")
    @concentrated = @concentrated_report.one_month(Date.current)
    @total = set_total
    @module = "concentrated_reports_sales"
    respond_to do |format|
      format.html {}
      format.js { render :search }
      format.xlsx {
        @title = 'Reporte Simplificado de Ventas'
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
        render xlsx: @title, template: 'concentrated_reports/sales'
      }
    end
  end

  def sales_by_month_year
    if params[:search].present?
      year = (params[:search][:year]).to_i
      month = (params[:search][:month]).to_i
      day = 1
      date = Date.new(year, month, day)
    else
      date = (session["sales_by_month_year"]).to_date
    end

    initialize_variables("sales")
    @concentrated = @concentrated_report.one_month(date)
    @total = set_total
    respond_to do |format|
      format.html {}
      format.js {
        session["sales_by_month_year"] = date
        render :concentrated_sales
      }
      format.xlsx {
        @title = 'Reporte Simplificado de Ventas'
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
        render xlsx: @title, template: 'concentrated_reports/sales'
      }
    end
  end

  def sales_by_year
    if params[:search].present?
      year = (params[:search][:year]).to_i
    else
      year = (session[:sales_by_year]).to_i
    end

    initialize_variables("sales")
    @concentrated = @concentrated_report.all_months(year)
    @total = set_total
    respond_to do |format|
      format.html {}
      format.js {
        session[:sales_by_year] = year
        render :concentrated_sales }
      format.xlsx {
        @title = 'Reporte Simplificado de Ventas'
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
        render xlsx: @title, template: 'concentrated_reports/sales'
      }
    end
  end

  # Concentrated Reports for Services
  def services
    initialize_variables("services")
    @concentrated = @concentrated_report.one_month(Date.current)
    @total = set_total
    @module = "concentrated_reports_services"
    respond_to do |format|
      format.html {}
      format.js { render :search }
      format.xlsx {
        @title = 'Reporte Simplificado de Servicios'
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
        render xlsx: @title, template: 'concentrated_reports/services'
      }
    end
  end

  def services_by_month_year
    if params[:search].present?
      year = (params[:search][:year]).to_i
      month = (params[:search][:month]).to_i
      day = 1
      date = Date.new(year, month, day)
    else
      date = (session["services_by_month_year"]).to_date
    end

    initialize_variables("services")
    @concentrated = @concentrated_report.one_month(date)
    @total = set_total
    respond_to do |format|
      format.html {}
      format.js {
        session["services_by_month_year"] = date
        render :concentrated_services
      }
      format.xlsx {
        @title = 'Reporte Simplificado de Servicios'
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
        render xlsx: @title, template: 'concentrated_reports/services'
      }
    end
  end

  def services_by_year
    if params[:search].present?
      year = (params[:search][:year]).to_i
    else
      year = (session[:sales_by_year]).to_i
    end

    initialize_variables("services")
    @concentrated = @concentrated_report.all_months(year)
    @total = set_total
    respond_to do |format|
      format.html {}
      format.js {
        session[:services_by_year] = year
        render :concentrated_services }
      format.xlsx {
        @title = 'Reporte Simplificado de Servicios'
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
        render xlsx: @title, template: 'concentrated_reports/services'
      }
    end
  end

  private

  def initialize_variables(type)
    set_concentrated_report(type)
    set_months
    set_years
  end

  def set_concentrated_report(type)
    @concentrated_report = ConcentratedReportPolicy.new(type)
  end

  def set_months
    @months = @concentrated_report.months_select
  end

  def set_years
    @years = @concentrated_report.years_select
  end

  def set_total
    @concentrated_report.all_total
  end

end
