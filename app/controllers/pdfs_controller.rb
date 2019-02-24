class PdfsController < ApplicationController
  before_action :set_service

  def ticket_paid_services
    respond_to do |format|
      format.pdf do
        @service.total_tickets += 1
        @service.save
        @ticket_service = TicketService.new(@service)
        render pdf: 'report',
               #wkhtmltopdf: route_wicked,
               template: 'pdfs/ticket_paid_service.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               page_size: 'A7',
               margin: {
                 top: 5,
                 bottom: 4
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
               #wkhtmltopdf: route_wicked,
               template: 'pdfs/note_service.pdf.html.erb',
               background: true,
               layout: 'pdf.html.erb',
               page_size: 'A4',
               margin: {
                 top: 10,
                 bottom: 40
               }
      end
    end
  end

  private

  def set_service
    @service = Service.find(params[:id_service])
  end
end
