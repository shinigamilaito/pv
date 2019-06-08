class InvitationPrintingProduct < ApplicationRecord
  belongs_to :user
  belongs_to :invitation, optional: true
  belongs_to :printing_product
end
