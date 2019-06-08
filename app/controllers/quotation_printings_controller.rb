class QuotationPrintingsController < ApplicationController
  before_action :set_module

  def index
    @clients = []
    @quotation_printings = []
    @quotation_printing = nil
  end

  def find_quotation_printings_by_client
    quotation_printing_policy = QuotationPrintingsPolicy.new(params[:client][:id].to_i)
    @quotation_printings = quotation_printing_policy.find_quotation_printings[:quotation_printings_present]
  end

  def new
    @quotation_printing = QuotationPrinting.new
    @quotation_printing.client_id = params[:client_id]
  end

  private

  def set_module
    @module = "OrdenTrabajo"
  end

end
