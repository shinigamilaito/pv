class IncomesController < ApplicationController
  before_action :check_is_admin, only: [:index]

  def index
    @incomes = Payment.where(paid: true).order(updated_at: :desc)
  end

  def pending_services
    @pending_services = ServicesPolicy.pending_services.order(updated_at: :desc)
  end

  def pending_service_by_client
    @pending_services = ServicesPolicy.pending_service_by_client(params[:search]).order(updated_at: :desc)
  end

  def search
    @incomes = Payment.search(params[:search]).order(created_at: :desc)
  end

  private

  def check_is_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
