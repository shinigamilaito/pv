# Gestiona las reglas de negocio
# para el modulo de cotizaciones
class QuotationsPolicy
  attr_reader :user #Usuario registrado en el sistema
  attr_reader :product_code #Codigo del producto

  def initialize(product_code = '', user)
    @product_code = product_code
    @user = user
  end

  # Productos que el usuario
  # agrego a una cotizacion y no han
  # sido asociados a un cliente
  def products
    user
      .quotation_products
      .where(quotation_id: nil)
      .order(created_at: :desc)
  end

  # Elimina los productos que
  # se hayan agregado a una cotizacion
  # y no se hayan guardado en la base de datos
  def remove_products
    products.each do |quotation_product|
      delete(quotation_product)
    end
  end

  # Agrega el producto perteneciente al
  # código, a una cotizacion
  def add_product(quantity = 1, is_increment = true)
    new_product = false

    if product.present?
      if pending_in_quotation?
        product = adjust_product(quantity, is_increment)
      else
        product = adjust_new_product
        new_product = true
      end
    else
      raise 'Producto no encontrado'
    end

    return {
      new: new_product,
      product: product
    }
  end

  # Obtiene el total de los productos
  # que han sido agregados a la cotización
  def totals
    total_final = cost_products

    return {
      total_final: total_final    
    }
  end

  # Actualiza el precio del producto
  # ajusta el nuevo porcentaje aplicado
  def change_price_product(quotation_product_id, new_price)
    @quotation_product = QuotationProduct.find(quotation_product_id)
    current_price = @quotation_product.quantity * @quotation_product.price

    new_discount = (new_price / current_price) * BigDecimal.new("100")
    @quotation_product.discount = BigDecimal.new("100.0") - new_discount
    @quotation_product.real_price = new_price / @quotation_product.quantity
    @quotation_product.save

    return @quotation_product
  end

  def delete(quotation_product)
    raise 'Error al eliminar el producto' unless quotation_product.destroy
  end

  private

  # Producto perteneciente al código
  def product
    @product ||= Product.search_for_sales(product_code).order(created_at: :desc).first
  end

  # Verifica si exite un producto en proceso
  def pending_in_quotation?
    quotation_product.present?
  end

  # Obtiene producto asociado a una cotizacion en proceso
  def quotation_product
    @quotation_product ||= user.quotation_products.where(code: product_code, quotation_id: nil).first
  end

  # Ajusta las cantidades del producto que se agrega a
  # la cotización
  def adjust_product(quantity, is_increment)
    raise 'No fue posible ajustar la cantidad del producto.' unless adjust_quantity_quotation_product(quantity, is_increment)
    quotation_product
  end

  # Ajusta las cantidades del producto en la cotización
  # el incremento es por unidad.
  def adjust_quantity_quotation_product(new_quantity, is_increment)
    if is_increment
      quotation_product.quantity += new_quantity
    else
      quotation_product.quantity = new_quantity
    end

    quotation_product.save
  end

  # Crea el registro del producto
  # en una cotización en proceso
  def adjust_new_product
    quotation_product = new_quotation_product
    quotation_product.user = user
    raise 'Producto no agregado' unless quotation_product.save

    quotation_product
  end

  def new_quotation_product
    quotation_product = QuotationProduct.new
    quotation_product.code = product.code
    quotation_product.name = product.name
    quotation_product.quantity = 1
    quotation_product.price = product.price # Sin descuento
    quotation_product.real_price = product.price # Podria aplicarsele descuento
    quotation_product.product = product

    quotation_product
  end

  # Obtiene el costo total de los
  # productos que se agregan a la cotizacion
  def cost_products
    total = products.inject(BigDecimal("0.00")) do |total, product|
      total += product.total
      total
    end

    total
  end

end
