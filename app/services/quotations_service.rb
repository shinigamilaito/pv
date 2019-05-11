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

  def self.change_status
    PgLock.new(name: "quotations_service_change_status").lock do
      quotations = Quotation.where("status = ? AND created_at <= ?", "Vigente", Time.now.to_date - 1.month)

      quotations.each do |quotation|
        quotation.status = "No vigente"
        quotation.save
      end
    end
  end

  def self.delete_quotations
    PgLock.new(name: "quotations_service_delete_quotations").lock do
      quotations = Quotation.where("status = ? AND created_at <= ?", "No vigente", Time.now.to_date - 6.month)
      quotations.each { |quotation| quotation.destroy }
    end
  end
end
