class QuotationPrintingsPolicy
  attr_accessor :client_id

    NEW_QUOTATION = 'Nueva Cotización'

  def initialize(client_id = '')
    @client_id = client_id
  end

  def find_quotation_printings
    quotation_printings = QuotationPrinting
      .where(client_id: client_id)
      .order(created_at: :desc)

    quotation_printings_hash = {}
    quotation_printings_hash[:quotation_printings] = quotation_printings.map(&:number_folio)
    quotation_printings_hash[:quotation_printings_present] = quotation_printings.map do |quotation_printing|
       quotation_printings_with_date_creation(quotation_printing)
    end

    quotation_printings_hash[:quotation_printings_present].unshift(NEW_QUOTATION)
    quotation_printings_hash
  end

  def quotation_printings_with_date_creation(quotation_printing)
    date = ActionController::Base.helpers.l(quotation_printing.created_at, format: '%A, %d %b %Y %I:%M:%S')
    return "#{quotation_printing.number_folio} - Creado: #{date}."
  end


end
