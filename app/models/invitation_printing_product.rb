class InvitationPrintingProduct < ApplicationRecord
  belongs_to :user
  belongs_to :invitation, optional: true
  belongs_to :printing_product

  has_many :printing_product_quotations
end
