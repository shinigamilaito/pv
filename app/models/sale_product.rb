# == Schema Information
#
# Table name: sale_products
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  quantity   :integer
#  price      :decimal(10, 2)   default(0.0)
#  product_id :bigint
#  user_id    :bigint
#  sale_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  discount   :decimal(10, 2)   default(0.0)
#  real_price :decimal(20, 10)  default(0.0)
#

class SaleProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  def total
    self.quantity * self.real_price
  end
  
end
