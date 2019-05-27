class PrintingSaleProduct < ApplicationRecord
  belongs_to :printing_product
  belongs_to :user
  belongs_to :printing_sale, optional: true

  def total
    self.quantity * self.real_price
  end
end
