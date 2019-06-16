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
      printing_product_quotations = obtain_printing_product_quotations_in_use(invitation, user)

      if printing_product_quotations.blank?
        ActiveRecord::Base.transaction do
          invitation.invitation_printing_products.where(from_printing_products: true).each do |invitation_printing_product|
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
  end

  def obtain_printing_product_quotations_in_use(invitation, user)
    printing_product_quotations = user.printing_product_quotations
      .joins(:invitation_printing_product)
      .where("printing_product_quotations.quotation_printing_id IS NULL AND invitation_printing_products.invitation_id = ?", invitation.id)
  end

  def update_quantity(printing_product_quotation, quantity)
    printing_product_quotation.quantity = quantity
    printing_product_quotation.total = obtain_total(printing_product_quotation)
    raise "Imposible actualizar la cantidad" unless printing_product_quotation.save

    return printing_product_quotation
  end

  def totals(invitation, user, manufacturing_cost, amount_to_elaborate)
    cost_public_sale = cost_materials_public_sale(invitation, user)
    cost_purchase = cost_materials_purchase(invitation, user)
    cost_materials_public = cost_public_sale + manufacturing_cost
    cost_materials_purchase = cost_purchase + manufacturing_cost
    utility = (cost_public_sale - cost_purchase) + manufacturing_cost

    return {
      amount_to_elaborate: amount_to_elaborate,
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
  def add(user, invitation, printing_product)
    unless exist_in_the_list?(user, invitation, printing_product)
      ActiveRecord::Base.transaction do
        raise 'Imposible agregar el producto imprenta' unless create_printing_product_quotation(user, invitation, printing_product)
      end
    else
      raise 'Producto imprenta ya ha sido agregado.'
    end
  end

  private

  def cost_materials_public_sale(invitation, user)
    total = obtain_printing_product_quotations_in_use(invitation, user).inject(BigDecimal("0.00")) do |total, printing_product_quotation|
      total += printing_product_quotation.total
      total
    end

    total
  end

  def cost_materials_purchase(invitation, user)
    total = obtain_printing_product_quotations_in_use(invitation, user).inject(BigDecimal("0.00")) do |total, printing_product_quotation|
      total += printing_product_quotation.purchase_price * printing_product_quotation.quantity
      total
    end

    total
  end

  def obtain_total(printing_product_quotation)
    BigDecimal(printing_product_quotation.real_price * printing_product_quotation.quantity)
  end

  def exist_in_the_list?(user, invitation, printing_product)
    printing_product_quotations = user.printing_product_quotations
      .joins(:invitation_printing_product)
      .where("printing_product_quotations.quotation_printing_id IS NULL AND invitation_printing_products.invitation_id = ? AND invitation_printing_products.printing_product_id = ?", invitation.id, printing_product.id)

    return printing_product_quotations.present?
  end

  def create_printing_product_quotation(user, invitation, printing_product)
    invitation_printing_product = InvitationPrintingProduct.new
    invitation_printing_product.user = user
    invitation_printing_product.invitation = invitation
    invitation_printing_product.printing_product = printing_product
    invitation_printing_product.from_printing_products = invitation.created_in_quotation

    printing_product_quotation = PrintingProductQuotation.new
    printing_product_quotation.invitation_printing_product = invitation_printing_product
    printing_product_quotation.user = user
    printing_product_quotation.code = printing_product.code
    printing_product_quotation.name = printing_product.name
    printing_product_quotation.quantity = 1
    printing_product_quotation.purchase_price = printing_product.purchase_price
    printing_product_quotation.real_price = printing_product.sale_price
    printing_product_quotation.total = printing_product.sale_price
    printing_product_quotation.sale_unit = printing_product.sale_unit

    printing_product_quotation.save
  end

end
