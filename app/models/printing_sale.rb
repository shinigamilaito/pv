class PrintingSale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  belongs_to :client, optional: true
  belongs_to :cash_opening_impression

  has_many :printing_sale_products
  has_many :partial_sales
end
