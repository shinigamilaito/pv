class QuotationPrinting < ApplicationRecord
  belongs_to :invitation
  belongs_to :client
end
