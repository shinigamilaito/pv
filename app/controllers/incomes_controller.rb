class IncomesController < ApplicationController
  def index
    @incomes = Payment.where(paid: true).order(updated_at: :desc)
  end

  def pending_services
    @pending_services = Payment.where(paid: false).order(updated_at: :desc)
  end

  def search
    @incomes = Payment.search(params[:search]).order(created_at: :desc)
  end
end
