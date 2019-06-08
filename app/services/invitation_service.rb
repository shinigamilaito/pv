class InvitationService
  attr_accessor :printing_product, :user

  def initialize(printing_product, user)
    @printing_product = printing_product
    @user = user
  end

  def create_invitation_printing_product
    if printing_product_exist?
      raise 'El producto ya esta en la lista'
    end

    invitation_printing_product = InvitationPrintingProduct.new
    invitation_printing_product.user = @user
    invitation_printing_product.printing_product = @printing_product
    raise 'Error al registrar la refacción' unless invitation_printing_product.save
  end

  private

  def printing_product_exist?
    @user
      .invitation_printing_products
      .where(invitation_id: nil, printing_product_id: @printing_product.id)
      .present?
  end


end
