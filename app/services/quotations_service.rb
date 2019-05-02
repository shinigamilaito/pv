class QuotationsService

  def initialize(quotations_policy, quotation)
    @quotations_policy = quotations_policy
    @quotation = quotation
  end

  def save
    PgLock.new(name: "quotations_service_save").lock do
      @quotations_policy.products.each do |product|
        @quotation.quotation_products << product
      end

      @quotation.folio = Quotation.count + 1
      @quotation.save
    end
  end
end
