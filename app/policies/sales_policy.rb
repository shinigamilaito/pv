class SalesPolicy
  attr_reader :product_name, :user

  def initialize(product_name, user)
    @product_name = product_name
    @user = user
  end

  def add_product
    product = Product.search_for_sales(product_name).order(created_at: :desc).first
    new_product = false

    if product.present?
      if product.available?(1)
        if user.pending_in_sale?(product.code)
          product = adjust_product_in_sale(product)
        else
          product = adjust_new_product_to_sale(product)
          new_product = true
        end
      else
        raise 'Producto no disponible.'
      end
    else
      raise 'Producto no encontrado.'
    end

    return {
      new: new_product,
      product: product
    }
  end

  private

  def adjust_product_in_sale(product)
    ActiveRecord::Base.transaction do
      sale_product = user.give_me_product(product.code)
      raise 'No fue posible ajustar la cantidad del producto.' unless sale_product.adjust_quantity(1)
      raise 'No fue posible decrementar el stock' unless product.decrement_total
      sale_product
    end
  end

  def adjust_new_product_to_sale(product)
    ActiveRecord::Base.transaction do
      sale_product = SaleProduct.new_from(product)
      sale_product.user = user
      raise 'Producto no creado' unless sale_product.save
      raise 'No fue posible decrementar el stock' unless product.decrement_total
      sale_product
    end
  end

end
