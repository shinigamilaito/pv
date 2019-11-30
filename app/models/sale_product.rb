# == Schema Information
#
# Table name: sale_products
#
#  id             :bigint           not null, primary key
#  code           :string
#  discount       :decimal(10, 2)   default(0.0)
#  name           :string
#  price          :decimal(10, 2)   default(0.0)
#  purchase_price :decimal(10, 2)   default(0.0)
#  quantity       :integer
#  real_price     :decimal(20, 10)  default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  product_id     :bigint
#  sale_id        :bigint
#  user_id        :bigint
#

class SaleProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  def total
    self.quantity * self.real_price
  end

  def real_purchase_price
    if self.purchase_price == BigDecimal.new("0.0", 2)
      return self.product.price_purchase.present? ? self.product.price_purchase : self.purchase_price
    else
      return self.purchase_price
    end
  end

  def earning
    return self.real_price - self.real_purchase_price
  end
  
end
