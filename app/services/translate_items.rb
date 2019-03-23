class TranslateItems

  def translate_products_to_spare_parts(product)
    PgLock.new(name: "translate_items_translate_products_to_spare_parts").lock do
      ActiveRecord::Base.transaction do
        if product.quantity <= 0
          raise 'Stock no suficiente.'
        else
          spare_part = find_spare_part(product.code)
          spare_part.code = product.code
          spare_part.name = product.name
          spare_part.total += 1
          spare_part.price = product.price
          spare_part.description = product.description
          raise 'Error al realizar el traspaso' unless spare_part.save
          raise 'Error al realizar el traspaso' unless decrement_product(product)
        end
      end
    end
  end

  def translate_spare_parts_to_products(spare_part)
    PgLock.new(name: "translate_items_translate_spare_parts_to_products").lock do
      ActiveRecord::Base.transaction do
        if spare_part.total <= 0
          raise 'Stock no suficiente.'
        else
          product = find_product(spare_part.code)
          product.code = spare_part.code
          product.name = spare_part.name
          product.quantity += 1
          product.price = spare_part.price
          product.description = spare_part.description
          raise 'Error al realizar el traspaso' unless product.save
          raise 'Error al realizar el traspaso' unless decrement_spare_part(spare_part)
        end
      end
    end
  end

  private

  def find_spare_part(code)
    spare_part = SparePart.find_by_code(code)

    if spare_part.nil?
      spare_part = SparePart.new
      spare_part.total = 0
    end

    return spare_part
  end

  def decrement_product(product)
    product.quantity -= 1
    product.save
  end

  def find_product(code)
    product = Product.find_by_code(code)

    if product.nil?
      product = Product.new
      product.quantity = 0
    end

    return product
  end

  def decrement_spare_part(spare_part)
    spare_part.total -= 1
    spare_part.save
  end

end
