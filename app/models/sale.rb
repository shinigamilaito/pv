class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  has_many :sale_products
end
