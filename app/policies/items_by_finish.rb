class ItemsByFinish

  def initialize
  end

  def elements
    public_products + public_spare_parts
  end

  private

  def public_products
    return products.map do |product|
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
    return Product.select do |product|
      product.quantity <= product.stock_minimum
    end
  end

  def public_spare_parts
    return spare_parts.map do |spare_part|
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
    return SparePart.select do |spare_part|
      spare_part.total <= spare_part.stock_minimum
    end
  end
end
