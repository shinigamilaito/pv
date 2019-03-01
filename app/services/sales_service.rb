class SalesService

  def initialize(sales_policy, sale)
    @sales_policy = sales_policy
    @sale = sale
  end

  def save
    @sales_policy.products_for_sale.each do |product|
      @sale.sale_products << product
    end

    @sale.save
  end
end
