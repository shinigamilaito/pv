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
    return "#{quotation_printing.number_folio} - Creado: #{date}. - #{quotation_printing.status}"
  end

  def generate_printing_product(invitation, user, quotation_printing_id = nil)
=begin
    if quotation_printing_id.present?
      quotation_printing = QuotationPrinting.find(quotation_printing_id)
      quotation_printing.printing_product_quotations.destroy_all
    else
      printing_product_quotations = obtain_printing_product_quotations_in_use(invitation, user)
      printing_product_quotations.destroy_all
    end
=end

    printing_product_quotations = obtain_printing_product_quotations_in_use(invitation, user)
    printing_product_quotations.destroy_all

    PgLock.new(name: "quotation_printings_policy_generate_printing_product").lock do
      #printing_product_quotations = obtain_printing_product_quotations_in_use(invitation, user)

      #if printing_product_quotations.blank?
        ActiveRecord::Base.transaction do
          invitation.invitation_printing_products.each do |invitation_printing_product|
            printing_product_quotation = PrintingProductQuotation.new
            #printing_product_quotation.invitation_printing_product = invitation_printing_product
            printing_product_quotation.quotation_printing_id = quotation_printing_id
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
      #end
    end
  end

  def obtain_printing_product_quotations_in_use(invitation, user, quotation_printing_id = nil)
    if quotation_printing_id.nil?
      return user.printing_product_quotations
                 .where("printing_product_quotations.quotation_printing_id IS NULL")
                 # .joins(:invitation_printing_product)
                 # .where("printing_product_quotations.quotation_printing_id IS NULL")
    else
      quotation_printing = QuotationPrinting.find(quotation_printing_id)
      return quotation_printing.printing_product_quotations
    end
  end

  def update_quantity(printing_product_quotation, quantity)
    printing_product_quotation.quantity = quantity
    printing_product_quotation.total = obtain_total(printing_product_quotation)
    raise "Imposible actualizar la cantidad" unless printing_product_quotation.save

    return printing_product_quotation
  end

  def totals(invitation, user, manufacturing_cost, amount_to_elaborate, quotation_printing_id = nil)
    cost_public_sale = cost_materials_public_sale(invitation, user, quotation_printing_id)
    cost_purchase = cost_materials_purchase(invitation, user, quotation_printing_id)
    cost_materials_public = cost_public_sale + manufacturing_cost
    cost_materials_purchase = cost_purchase + manufacturing_cost
    utility = (cost_public_sale - cost_purchase) + manufacturing_cost

    if quotation_printing_id.present?
      quotation_printing = QuotationPrinting.find(quotation_printing_id)
      quotation_printing.cost_elaboration = manufacturing_cost
      quotation_printing.total_pieces = amount_to_elaborate
      quotation_printing.total_quotations = cost_materials_public
      quotation_printing.total_cost = cost_materials_purchase
      quotation_printing.utility = utility
      quotation_printing.save
    end

    return {
        amount_to_elaborate: amount_to_elaborate,
        cost_materials_public: cost_materials_public,
        cost_materials_purchase: cost_materials_purchase,
        utility: utility
    }
  end

  # Obtiene el costo total para una cotización ya registrada
  def totals_by_quotation(quotation_printing)
    cost_materials_public = quotation_printing.total_quotations
    cost_materials_purchase = quotation_printing.total_cost
    utility = quotation_printing.utility

    return {
        amount_to_elaborate: quotation_printing.total_pieces,
        cost_materials_public: cost_materials_public,
        cost_materials_purchase: cost_materials_purchase,
        utility: utility
    }
  end

  # Actualiza el precio en total del producto
  def change_price_product(printing_product_quotation, new_price)
    printing_product_quotation.real_price = new_price / printing_product_quotation.quantity
    printing_product_quotation.total = new_price
    raise "Imposible actualizar el precio final" unless printing_product_quotation.save

    return printing_product_quotation
  end

  # Actualiza el precio del producto por unidad
  def change_real_price_product(printing_product_quotation, real_price)
    printing_product_quotation.real_price = real_price
    printing_product_quotation.total = obtain_total(printing_product_quotation)
    raise "Imposible actualizar el precio unitario" unless printing_product_quotation.save

    return printing_product_quotation
  end

  def destroy_printing_product_quotations(user)
    user.printing_product_quotations.where(quotation_printing_id: nil).each do |printing_product_quotation|
      raise 'Error al generar los productos imprenta' unless printing_product_quotation.destroy
    end
  end

  # Add printing_product to quotation
  def add(user, invitation, printing_product, quotation_printing_id = nil)
    unless exist_in_the_list?(user, invitation, printing_product, quotation_printing_id)
      ActiveRecord::Base.transaction do
        raise 'Imposible agregar el producto imprenta' unless create_printing_product_quotation(user, invitation, printing_product, quotation_printing_id)
      end
    else
      raise 'Producto imprenta ya ha sido agregado.'
    end
  end

  private

  def cost_materials_public_sale(invitation, user, quotation_printing_id = nil)
    total = obtain_printing_product_quotations_in_use(invitation, user, quotation_printing_id).inject(BigDecimal("0.00")) do |total, printing_product_quotation|
      total += printing_product_quotation.total
      total
    end

    total
  end

  def cost_materials_purchase(invitation, user, quotation_printing_id)
    total = obtain_printing_product_quotations_in_use(invitation, user, quotation_printing_id).inject(BigDecimal("0.00")) do |total, printing_product_quotation|
      total += printing_product_quotation.purchase_price * printing_product_quotation.quantity
      total
    end

    total
  end

  def obtain_total(printing_product_quotation)
    BigDecimal(printing_product_quotation.real_price * printing_product_quotation.quantity)
  end

  def exist_in_the_list?(user, invitation, printing_product, quotation_printing_id = nil)
    if quotation_printing_id.present?
      quotation_printing = QuotationPrinting.find(quotation_printing_id)
      printing_product_quotations = quotation_printing.printing_product_quotations.where(id: printing_product.id)

      return printing_product_quotations.present?

    else
      printing_product_quotations = user.printing_product_quotations
                                        .where("quotation_printing_id IS NULL AND code = ?", printing_product.code)
                                        # .joins(:invitation_printing_product)


      return printing_product_quotations.present?
    end
  end

  def create_printing_product_quotation(user, invitation, printing_product, quotation_printing_id = nil)
=begin
    invitation_printing_product = InvitationPrintingProduct.new
    invitation_printing_product.user = user
    invitation_printing_product.invitation = invitation
    invitation_printing_product.printing_product = printing_product
    invitation_printing_product.from_printing_products = invitation.created_in_quotation
=end

    printing_product_quotation = PrintingProductQuotation.new
    # printing_product_quotation.invitation_printing_product = invitation_printing_product
    printing_product_quotation.user = user
    printing_product_quotation.code = printing_product.code
    printing_product_quotation.name = printing_product.name
    printing_product_quotation.quantity = 1
    printing_product_quotation.purchase_price = printing_product.purchase_price
    printing_product_quotation.real_price = printing_product.sale_price
    printing_product_quotation.total = printing_product.sale_price
    printing_product_quotation.sale_unit = printing_product.sale_unit
    printing_product_quotation.quotation_printing_id = quotation_printing_id

    printing_product_quotation.save
  end

end
