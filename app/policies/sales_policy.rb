# Before made the sale
class SalesPolicy
  attr_reader :product_code, :user

  def initialize(product_code = '', user)
    @product_code = product_code
    @user = user
  end

  def add_product(quantity = 1, is_increment = true)
    PgLock.new(name: "sales_policy_add_product").lock do
      new_product = false

      if product.present?
        if available?(quantity, is_increment)
          if pending_in_sale?
            product = adjust_product_in_sale(quantity, is_increment)
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
  end

  def products_for_sale
    user.sale_products.where(sale_id: nil).order(created_at: :desc)
  end

  def delete(sale_product, product)
    PgLock.new(name: "sales_policy_add_product").lock do
      ActiveRecord::Base.transaction do
        @product = product
        quantity = sale_product.quantity
        raise 'Error al actualizar la cantidad.' unless adjust_quantity_product(quantity)
        raise 'Error al eliminar el producto.' unless sale_product.destroy
      end
    end
  end

  def totals(discount = '0')
    total_products = cost_products
    total_discount = obtain_discount(discount)
    total_final = total_products - total_discount

    return {
      total_products: total_products,
      total_discount: total_discount,
      discount_percentage: discount,
      total_final: total_final,
      paid_with: BigDecimal.new('0'),
      change: BigDecimal.new('0')
    }
  end

  def remove_products_in_sale
    products_for_sale.each do |sale_product|
      delete(sale_product, sale_product.product)
    end
  end

  # Obtener el precio para el producto al aplicar
  # un descuento en porcentaje
  def obtain_discount_by_product(sale_product_id, discount_percentage)
    @sale_product = SaleProduct.find(sale_product_id)
    if discount_percentage != @sale_product.discount
      @sale_product.discount = discount_percentage
      #@sale_product.price -= (discount_percentage * @sale_product.price) / 100.0
      @sale_product.save
    end

    return @sale_product
  end

  # Actualiza el precio del producto
  # ajusta el nuevo porcentaje aplicado
  def change_price_product(sale_product_id, new_price)
    @sale_product = SaleProduct.find(sale_product_id)
    current_price = @sale_product.quantity * @sale_product.price

    new_discount = (new_price / current_price) * BigDecimal.new("100")
    @sale_product.discount = BigDecimal.new("100.0") - new_discount
    @sale_product.real_price = new_price / @sale_product.quantity
    @sale_product.save

    return @sale_product
  end

  private

  def adjust_product_in_sale(quantity, is_increment)
    ActiveRecord::Base.transaction do
      raise 'No fue posible ajustar la cantidad del producto.' unless adjust_quantity_sale_product(quantity, is_increment)
      raise 'No fue posible decrementar el stock' unless decrement_total_product(quantity)
      sale_product
    end
  end

  def adjust_new_product_to_sale
    ActiveRecord::Base.transaction do
      sale_product = new_sale_product
      sale_product.user = user
      raise 'Producto no creado' unless sale_product.save
      raise 'No fue posible decrementar el stock' unless decrement_total_product(1)
      sale_product
    end
  end

  def product
    @product ||= Product.search_for_sales(product_code).order(created_at: :desc).first
  end

  def available?(quantity, is_increment)
    if pending_in_sale?
      unless is_increment
        product.quantity + sale_product.quantity >= quantity
      else
        product.quantity >= quantity
      end
    else
      product.quantity >= quantity
    end
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
    sale_product.price = product.price # Sin descuento
    sale_product.real_price = product.price # Podria aplicarsele descuento
    sale_product.product = product

    sale_product
  end

  def adjust_quantity_sale_product(new_quantity, is_increment)
    if is_increment
      sale_product.quantity += new_quantity
    else
      raise 'Error al ajustar el stock' unless adjust_quantity_product(sale_product.quantity)
      sale_product.quantity = new_quantity
    end
    sale_product.save
  end

  def decrement_total_product(quantity)
    product.quantity -= quantity
    product.save
  end

  # Se restablece la cantidad del producto
  # después de eliminarlo de la venta
  def adjust_quantity_product(quantity)
    product.quantity += quantity
    product.save
  end

  def cost_products
    total = products_for_sale.inject(BigDecimal("0.00")) do |total, product|
      total += total_cost(product)
      total
    end

    total
  end

  def total_cost(product)
    BigDecimal(product.real_price * product.quantity)
  end

  def obtain_discount(discount)
    total_products = cost_products
    total_discount = BigDecimal.new(discount)
    total_percentaje = total_products * total_discount

    return (total_percentaje / BigDecimal.new('100.00'))
  end
end
