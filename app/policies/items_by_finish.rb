class ItemsByFinish
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def elements
    if user.sales_product?
      public_products + public_spare_parts
    else
      public_printing_products
    end
  end

  private

  def public_printing_products
    printing_products.map do |printing_product|
      {
          id: printing_product.id,
          code: printing_product.code,
          description: printing_product.name,
          area: 'Productos Imprenta',
          stock: printing_product.stock || 0,
          status: printing_product.stock == 0 ? 'Agotado' : 'Por agotarse',
          name_class: printing_product.stock == 0 ? 'items_terminated' : 'items_by_terminated'
      }
    end
  end

  def printing_products
    minimum_stock = 5
    PrintingProduct.select do |printing_product|
      stock = printing_product.stock
      stock == nil || printing_product.stock <= minimum_stock
    end
  end

  def public_products
    products.map do |product|
      {
        id: product.id,
        code: product.code,
        description: product.name,
        area: 'Productos',
        stock: product.quantity,
        status: product.quantity == 0 ? 'Agotado' : 'Por agotarse',
        name_class: product.quantity == 0 ? 'items_terminated' : 'items_by_terminated'
      }
    end

  end

  def products
    Product.select do |product|
      product.quantity <= product.stock_minimum
    end
  end

  def public_spare_parts
    spare_parts.map do |spare_part|
      {
        id: spare_part.id,
        code: spare_part.code,
        description: spare_part.name,
        area: 'Refacciones',
        stock: spare_part.total,
        status: spare_part.total == 0 ? 'Agotado' : 'Por agotarse',
        name_class: spare_part.total == 0 ? 'items_terminated' : 'items_by_terminated'
      }
    end

  end

  def spare_parts
    SparePart.select do |spare_part|
      spare_part.total <= spare_part.stock_minimum
    end
  end
end
