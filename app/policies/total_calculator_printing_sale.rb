# After made the sale
class TotalCalculatorPrintingSale
  attr_accessor :printing_sale, :paid_with, :change

  def initialize(printing_sale, paid_with, change)
    @printing_sale = printing_sale
    @paid_with = paid_with
    @change = change
  end

  def totals
    total_products = cost_products
    total_final = total_products

    return {
      total_products: total_products,
      total_final: total_final,
      paid_with: get_paid_with,
      change: get_change
    }
  end

  private

  def get_paid_with
    printing_sale.paid_with
  end

  def get_change
    printing_sale.change
  end

  def cost_products
    total = sale_products.inject(BigDecimal("0.00")) do |total, product|
      total += total_cost(product)
      total
    end

    total
  end

  def sale_products
    printing_sale.printing_sale_products
  end

  def total_cost(product)
    BigDecimal(product.real_price * product.quantity)
  end

end
