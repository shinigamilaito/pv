class PrintingSalesService

  def initialize(printing_sales_policy, printing_sale)
    @printing_sales_policy = printing_sales_policy
    @printing_sale = printing_sale
  end

  def save
    PgLock.new(name: "printing_sales_service_save").lock do
      @printing_sales_policy.products_for_sale.each do |product|
        @printing_sale.printing_sale_products << product
      end

      @printing_sale.ticket = PrintingSale.count + 1
      @ticket_sale = TicketPrintingSale.new(@printing_sale, @printing_sale.paid_with, @printing_sale.change, @printing_sale.payment_type)
      #@printing_sale.cash_opening_services_sale = CashPolicy.new.cash_services_sales
      @printing_sale.subtotal = @ticket_sale.totals[:subtotal]
      @printing_sale.total = @ticket_sale.totals[:total]
      @printing_sale.cash_opening_impression = CashPolicy.new.cash_impressions
      @printing_sale.save
    end
  end
end
