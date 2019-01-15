class IncomesController < ApplicationController
  def index
    @incomes = Service.where(paid: true).order(created_at: :desc)
  end
end
