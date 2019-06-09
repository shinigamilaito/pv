class QuotationPrinting < ApplicationRecord
  belongs_to :invitation
  belongs_to :client

  has_many :printing_product_quotations
end
