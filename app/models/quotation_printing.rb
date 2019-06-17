class QuotationPrinting < ApplicationRecord
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
end
