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

  def generate_printing_product(invitation, user)
    PgLock.new(name: "quotation_printings_policy_generate_printing_product").lock do
      ActiveRecord::Base.transaction do
        destroy_printing_product_quotations(user)

        invitation.invitation_printing_products.each do |invitation_printing_product|
          printing_product_quotation = PrintingProductQuotation.new
          printing_product_quotation.invitation_printing_product = invitation_printing_product
          printing_product_quotation.user = user
          printing_product_quotation.code = invitation_printing_product.printing_product.code
          printing_product_quotation.name = invitation_printing_product.printing_product.name
          printing_product_quotation.quantity = 1
          printing_product_quotation.purchase_price = invitation_printing_product.printing_product.purchase_price
          printing_product_quotation.real_price = invitation_printing_product.printing_product.sale_price
          printing_product_quotation.total = invitation_printing_product.printing_product.sale_price
          printing_product_quotation.sale_unit = invitation_printing_product.printing_product.sale_unit

          raise 'Error al obtener los productos imprenta' unless printing_product_quotation.save
        end
      end
    end
  end

  def obtain_printing_product_quotations_in_use(invitation, user)
    user.printing_product_quotations
      .joins(:invitation_printing_product)
      .where("printing_product_quotations.quotation_printing_id IS NULL AND invitation_printing_products.invitation_id = ?", invitation.id)
  end

  private

  def destroy_printing_product_quotations(user)
    user.printing_product_quotations.where(quotation_printing_id: nil).each do |printing_product_quotation|
      raise 'Error al generar los productos imprenta' unless printing_product_quotation.destroy
    end
  end

end
