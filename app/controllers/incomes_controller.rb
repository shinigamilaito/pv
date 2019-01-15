class IncomesController < ApplicationController
  def index
    @incomes = Service.where(paid: true).order(updated_at: :desc)
  end
end
