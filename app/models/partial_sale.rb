class PartialSale < ApplicationRecord
  belongs_to :printing_sale
  belongs_to :payment_type
  belongs_to :user
  belongs_to :cash_opening_impression

end
