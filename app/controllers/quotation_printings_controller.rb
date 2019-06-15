class QuotationPrintingsController < ApplicationController
  before_action :set_module

  def index
    @clients = []
    @quotation_printings = []
    @quotation_printing = nil

    quotation_printings_policy = QuotationPrintingsPolicy.new
    quotation_printings_policy.destroy_printing_product_quotations(current_user)
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
    manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
    if params[:amount_to_elaborate] == ""
      amount_to_elaborate = 0
    else
      amount_to_elaborate = params[:amount_to_elaborate].to_i
    end
    invitation = Invitation.find(params[:invitation_id])
    @printing_products = invitation.invitation_printing_products
    quotation_printings_policy = QuotationPrintingsPolicy.new
    begin
      quotation_printings_policy.generate_printing_product(invitation, current_user)
      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(invitation, current_user)
      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar las cantidades del producto
  def update_quantity_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      quantity = params[:quantity].to_i
      invitation = Invitation.find(params[:invitation_id])
      printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotation = quotation_printings_policy.update_quantity(printing_product_quotation, quantity)

      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
      render 'quotation_printings/update_quantity'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar el precio en total del producto
  def update_price_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      new_price = BigDecimal.new(params[:price].gsub(',', ''))
      invitation = Invitation.find(params[:invitation_id])
      printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotation = quotation_printings_policy.change_price_product(printing_product_quotation, new_price)

      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
      render 'quotation_printings/update_quantity'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Actualizar el precio en unidad del producto
  def update_real_price_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      real_price = BigDecimal.new(params[:real_price].gsub(',', ''))
      invitation = Invitation.find(params[:invitation_id])
      printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotation = quotation_printings_policy.change_real_price_product(printing_product_quotation, real_price)

      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
      render 'quotation_printings/update_quantity'
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Obtiene el costo total después de un cambio en el costo de Elaboración
  def obtain_total_costs
    manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
    if params[:amount_to_elaborate] == ""
      amount_to_elaborate = 0
    else
      amount_to_elaborate = params[:amount_to_elaborate].to_i
    end
    invitation = Invitation.find(params[:invitation_id])
    quotation_printings_policy = QuotationPrintingsPolicy.new
    @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
  end

  def create
  end

  def add_printing_product
    begin
      manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
      if params[:amount_to_elaborate] == ""
        amount_to_elaborate = 0
      else
        amount_to_elaborate = params[:amount_to_elaborate].to_i
      end
      invitation = Invitation.find(params[:invitation_id])
      quotation_printings_policy = QuotationPrintingsPolicy.new
      printing_product = PrintingProduct.find(params[:printing_product][:id])
      quotation_printings_policy.add(current_user, invitation, printing_product)

      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(invitation, current_user)
      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
      render "obtain_printing_products"
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def delete_printing_product_quotation
    manufacturing_cost = BigDecimal.new(params[:manufacturing_cost].gsub(',', ''))
    if params[:amount_to_elaborate] == ""
      amount_to_elaborate = 0
    else
      amount_to_elaborate = params[:amount_to_elaborate].to_i
    end
    invitation = Invitation.find(params[:invitation_id])
    printing_product_quotation = PrintingProductQuotation.find(params[:printing_product_quotation_id])

    if printing_product_quotation.destroy
      quotation_printings_policy = QuotationPrintingsPolicy.new
      @printing_product_quotations = quotation_printings_policy.obtain_printing_product_quotations_in_use(invitation, current_user)
      @total_quotation_printings = quotation_printings_policy.totals(invitation, current_user, manufacturing_cost, amount_to_elaborate)
      render "obtain_printing_products"
    else
      render js: "toastr['error']('Imposible eliminar el producto imprenta de la cotización.');", status: :bad_request
    end
  end

  private

  def set_module
    @module = "OrdenTrabajo"
  end

end
