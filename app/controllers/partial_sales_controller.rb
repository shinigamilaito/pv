class PartialSalesController < ApplicationController
  before_action :set_module

  def index
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    @clients = []
    @partial_sales = []
    @partial_sale = nil
  end

  def find_partial_sales_by_client
    partial_sale_policy = PartialSalesPolicy.new(params[:client][:id].to_i)
    @partial_sales = partial_sale_policy.find_partial_sales[:partial_sales_present]
  end

  def new
    @printing_sale = PrintingSale.find_by_ticket(params[:ticket_printing_sale])
    partial_sale_policy = PartialSalesPolicy.new()
    @total = partial_sale_policy.total(@printing_sale)
    @total_payments = partial_sale_policy.total_payments(@printing_sale)

    @partial_sale = PartialSale.new
    @partial_sale.printing_sale = @printing_sale
    @partial_sale.difference = @total - @total_payments
  end

  def create
    unless cash_impression_open?
      flash[:warning] = 'La caja de impresiones no ha sido abierta.'
      redirect_to root_url and return
    end

    @partial_sale = PartialSale.new(partial_sale_params)
    @partial_sale.user = current_user
    @partial_sale.cash_opening_impression = CashPolicy.new.cash_impressions

    if @partial_sale.save
      @printing_sale = @partial_sale.printing_sale
      partial_sale_policy = PartialSalesPolicy.new()
      @total = partial_sale_policy.total(@printing_sale)
      @total_payments = partial_sale_policy.total_payments(@printing_sale)
      render 'partial_sales/create'
    else
      render js: "toastr['error']('Imposible realizar el pago. Intente nuevamente.');", status: :bad_request
    end
  end

  def generate_ticket
    @partial_sale = PartialSale.find(params[:id])
    respond_to do |format|
      format.pdf do
        @ticket_partial_sale = TicketPartialSale.new(@partial_sale)
        render pdf: 'report',
               wkhtmltopdf: route_wicked,
               template: 'partial_sales/ticket_paid.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               show_as_html: true,
               page_size: 'A8',
               margin: {
                 left: 0,
                 right: 0,
                 top: 5,
                 bottom: 4
               }
      end
    end
  end

  private

  def partial_sale_params
    params.require(:partial_sale).permit(:payment_type_id, :paid_with, :payment,
      :change, :difference, :printing_sale_id)
  end

  def set_module
    @module = "VentasParciales"
  end

end
