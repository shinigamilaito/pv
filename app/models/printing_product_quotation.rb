class PrintingProductQuotation < ApplicationRecord
  belongs_to :invitation_printing_product
  belongs_to :quotation_printing, optional: true
  belongs_to :user
end
