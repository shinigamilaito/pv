class CashClosingSale < ApplicationRecord
  belongs_to :user
  belongs_to :cash_opening_sale
end
