class SaleProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  def total
    self.quantity * self.real_price
  end
  
end
