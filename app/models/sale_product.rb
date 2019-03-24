class SaleProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  def total
    self.quantity * self.real_price
  end

  def real_price
    discount = BigDecimal.new((self.discount * self.price) / 100.0)
    return self.price - discount
  end
end
