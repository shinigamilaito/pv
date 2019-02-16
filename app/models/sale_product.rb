class SaleProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  def adjust_quantity(new_quantity)
    self.quantity += new_quantity
    self.save
  end
end
