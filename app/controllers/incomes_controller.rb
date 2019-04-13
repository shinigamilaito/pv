class IncomesController < ApplicationController
  before_action :check_is_admin, only: [:index]

  def index
    incomes = Payment
      .where(paid: true)

    @total = Payment.total(incomes)
    @incomes = incomes
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render :search }
      format.xlsx {
        @title = 'Ingresos por Servicios'
        @incomes_xlsx = incomes
        response.headers['Content-Disposition'] = "attachment; filename=#{@title}.xlsx"
      }
    end
  end

  def pending_services
    @pending_services = ServicesPolicy
      .pending_services
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :pending_services }
      format.js { render :pending_service_by_client }
    end
  end

  def pending_service_by_client
    @pending_services = ServicesPolicy
      .pending_service_by_client(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  def search
    @incomes = Payment
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

  def check_is_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
