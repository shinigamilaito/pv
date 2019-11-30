# Contains the relationship of printed products sold

# == Schema Information
#
# Table name: printing_sale_products
#
#  id                  :bigint           not null, primary key
#  code                :string
#  name                :string
#  price               :decimal(10, 2)   default(0.0)
#  purchase_price      :decimal(10, 2)   default(0.0)
#  quantity            :integer
#  real_price          :decimal(20, 10)  default(0.0)
#  real_sale_unit      :string
#  sale_unit           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  printing_product_id :bigint
#  printing_sale_id    :bigint
#  user_id             :bigint
#

class PrintingSaleProduct < ApplicationRecord
  belongs_to :printing_product
  belongs_to :user
  belongs_to :printing_sale, optional: true

  def total
    self.quantity * self.real_price
  end

  def update_fields_to(key_sale:, value_sale:, quantity:)
    self.real_sale_unit = key_sale
    self.sale_unit = value_sale
    self.price = self.printing_product.send(key_sale) * quantity
    self.real_price = self.printing_product.send(key_sale)
    self.save
  end

  def real_purchase_price
    if self.purchase_price == BigDecimal.new("0.0", 2)
      return self.printing_product.purchase_price.present? ? self.printing_product.purchase_price : self.purchase_price
    else
      return self.purchase_price
    end
  end

  def earning
    return self.real_price - self.real_purchase_price
  end
end
