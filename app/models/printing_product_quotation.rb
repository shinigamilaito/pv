class PrintingProductQuotation < ApplicationRecord
  belongs_to :invitation_printing_product, optional: true #No usado
  belongs_to :quotation_printing, optional: true
  belongs_to :user
end
