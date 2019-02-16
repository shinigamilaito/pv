class SalesPolicy
  attr_reader :product_code, :user

  def initialize(product_code = '', user)
    @product_code = product_code
    @user = user
  end

  def add_product
    new_product = false

    if product.present?
      if available?
        if pending_in_sale?
          product = adjust_product_in_sale
        else
          product = adjust_new_product_to_sale
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

  def products_for_sale
    user.sale_products.where(sale_id: nil).order(created_at: :desc)
  end

  def delete(sale_product, product)
    ActiveRecord::Base.transaction do
      quantity = sale_product.quantity
      product.adjust_quantity(quantity)
      sale_product.destroy
    end
  end

  private

  def adjust_product_in_sale
    ActiveRecord::Base.transaction do
      raise 'No fue posible ajustar la cantidad del producto.' unless sale_product.adjust_quantity(1)
      raise 'No fue posible decrementar el stock' unless product.decrement_total
      sale_product
    end
  end

  def adjust_new_product_to_sale
    ActiveRecord::Base.transaction do
      sale_product = new_sale_product
      sale_product.user = user
      raise 'Producto no creado' unless sale_product.save
      raise 'No fue posible decrementar el stock' unless product.decrement_total
      sale_product
    end
  end

  def product
    @product ||= Product.search_for_sales(product_code).order(created_at: :desc).first
  end

  def available?
    product.quantity >= 1
  end

  def pending_in_sale?
    sale_product.present?
  end

  def sale_product
    @sale_product ||= user.sale_products.where(code: product_code, sale_id: nil).first
  end

  def new_sale_product
    sale_product = SaleProduct.new
    sale_product.code = product.code
    sale_product.name = product.name
    sale_product.quantity = 1
    sale_product.price = product.price
    sale_product.product = product

    sale_product
  end
end
