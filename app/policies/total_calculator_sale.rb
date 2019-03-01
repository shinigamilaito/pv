# After made the sale
class TotalCalculatorSale
  attr_accessor :discount, :sale, :paid_with, :change

  def initialize(sale, paid_with, change, discount)
    @sale = sale
    @paid_with = paid_with
    @change = change
    @discount = discount
  end

  def totals
    total_products = cost_products
    total_discount = obtain_discount
    if sale.class == Sale
      total_final = sale.total
    else
      total_final = total_products - total_discount
    end

    return {
      total_products: total_products,
      total_discount: total_discount,
      total_final: total_final,
      paid_with: get_paid_with,
      change: get_change
    }
  end

  private

  def get_paid_with
    if sale.class == Sale
      sale.paid_with
    else
      paid_with
    end
  end

  def get_change
    if sale.class == Sale
      sale.change
    else
      change
    end
  end

  def cost_products
    total = sale_products.inject(BigDecimal("0.00")) do |total, product|
      total += total_cost(product)
      total
    end

    total
  end

  def obtain_discount
    total_products = cost_products
    if sale.class == Sale
      total_discount = sale.discount
      return total_discount
    else
      total_discount = discount
      total_percentaje = total_products * total_discount

      return (total_percentaje / BigDecimal.new('100.00'))
    end
  end

  def sale_products
    if sale.class == Sale
      sale.sale_products.order(created_at: :desc)
    else
      sale.sale_products.where(sale_id: nil).order(created_at: :desc)
    end
  end

  def total_cost(product)
    BigDecimal(product.price * product.quantity)
  end

end
