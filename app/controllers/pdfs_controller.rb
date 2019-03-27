class PdfsController < ApplicationController
  before_action :set_service, only: [:note_services]
  before_action :set_sale, only: [:ticket_paid_sales]

  def ticket_paid_sales
    respond_to do |format|
      format.pdf do
        @ticket_sale = TicketSale.new(@sale)
        render pdf: 'report',
               wkhtmltopdf: route_wicked,
               template: 'pdfs/ticket_paid_sale.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               page_size: 'A8',
               margin: {
                 top: 5,
                 bottom: 4
               }
      end
    end
  end

  def ticket_paid_services
    @payment = Payment.find(params[:id_payment])
    respond_to do |format|
      format.pdf do
        @ticket_service = TicketService.new(@payment)
        render pdf: 'report',
               #wkhtmltopdf: route_wicked,
               template: 'pdfs/ticket_paid_service.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               dpi: 600,
               page_height: '3000mm',
               page_width: '56mm',
               #page_size: 'A7',
               margin: {
                 left: 0,
                 top: 5,
                 bottom: 4,
                 right: 0
               }
      end
    end
  end

  def note_services
    respond_to do |format|
      format.pdf do
        @note_service = NoteService.new(@service)
        @components = Component.order(:created_at)
        render pdf: 'report',
               wkhtmltopdf: route_wicked,
               template: 'pdfs/note_service.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               page_width: '2.3in',
               dpi: 300,
               margin: {
                 top: 1,
                 bottom: 40
               }
      end
    end
  end

  private

  def set_service
    @service = Service.find(params[:id_service])
  end

  def set_sale
    @sale = Sale.find(params[:id_sale])
  end
end
