class QuotationPrinting < ApplicationRecord
  mount_uploader :imagen, InvitationUploader

  belongs_to :invitation
  belongs_to :client
  belongs_to :user
  belongs_to :payment_type, optional: true
  belongs_to :cash_opening_impression

  has_many :printing_product_quotations

  validates :client_id, :user_id, presence: true
  validates :number_folio, presence: true, uniqueness: {case_sensitive: true}

  before_create :set_number_folio

  def set_number_folio
    self.number_folio = QuotationPrinting.count + 1
  end

  def set_number_ticket
    return QuotationPrinting.count + 1 # + PartialPaymentQuotationPrinting.count
  end

  def self.total(quotation_printings)
    return nil if quotation_printings.blank?

    quotation_printings
      .map {|quotation_printing| quotation_printing.payment }
      .sum
  end
end
