# == Schema Information
#
# Table name: generic_prices
#
#  id         :bigint           not null, primary key
#  name       :string
#  price      :decimal(10, 2)   default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GenericPrice < ApplicationRecord
  validates :name, :price, presence: true
  validates :name, uniqueness: true

  def name_price
    return "#{self.name} - #{self.price}"
  end
end
