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

  def obtain_printing_products
    invitation = Invitation.find(params[:invitation_id])
    @printing_products = invitation.invitation_printing_products
    quotation_printings_policy = QuotationPrintingsPolicy.new
    begin
      quotation_printings_policy.generate_printing_product(invitation, current_user)
      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(invitation, current_user)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  private

  def set_module
    @module = "OrdenTrabajo"
  end

end
