# Contains the relationship of printed products sold

# == Schema Information
#
# Table name: printing_sale_products
#
#  id                  :bigint           not null, primary key
#  code                :string
#  name                :string
#  quantity            :integer
#  price               :decimal(10, 2)   default(0.0)
#  printing_product_id :bigint
#  user_id             :bigint
#  printing_sale_id    :bigint
#  real_price          :decimal(20, 10)  default(0.0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sale_unit           :string
#

class PrintingSaleProduct < ApplicationRecord
  belongs_to :printing_product
  belongs_to :user
  belongs_to :printing_sale, optional: true

  def total
    self.quantity * self.real_price
  end

  def update_fields_to(key_sale:, value_sale:)
    self.sale_unit = value_sale
    self.price = self.printing_product.send(key_sale)
    self.real_price = self.printing_product.send(key_sale)
    self.save
  end
end
