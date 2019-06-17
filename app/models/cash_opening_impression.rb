class CashOpeningImpression < ApplicationRecord
  belongs_to :user
  has_many :printing_sales
  has_many :partial_sales
  has_many :quotation_printings

  validates :type_cash, :open_date, :user_id, presence: true
  validates :amount, presence: true
end
