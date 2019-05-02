class QuotationProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :quotation, optional: true

  def total
    self.quantity * self.real_price
  end
end
