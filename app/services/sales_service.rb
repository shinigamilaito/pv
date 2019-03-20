class SalesService

  def initialize(sales_policy, sale)
    @sales_policy = sales_policy
    @sale = sale
  end

  def save
    PgLock.new(name: "sales_service_save").lock do
      @sales_policy.products_for_sale.each do |product|
        @sale.sale_products << product
      end

      @sale.ticket = Sale.count + 1
      @sale.save
    end
  end
end
