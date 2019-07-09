# == Schema Information
#
# Table name: quotation_products
#
#  id           :bigint           not null, primary key
#  code         :string
#  discount     :decimal(10, 2)   default(0.0)
#  name         :string
#  price        :decimal(10, 2)   default(0.0)
#  quantity     :integer
#  real_price   :decimal(20, 14)  default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  product_id   :bigint
#  quotation_id :bigint
#  user_id      :bigint
#

class QuotationProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :quotation, optional: true

  def total
    self.quantity * self.real_price
  end
end
