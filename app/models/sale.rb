# == Schema Information
#
# Table name: sales
#
#  id                            :bigint           not null, primary key
#  change                        :decimal(10, 2)   default(0.0)
#  discount                      :decimal(10, 2)   default(0.0)
#  paid_with                     :decimal(10, 2)   default(0.0)
#  subtotal                      :decimal(10, 2)   default(0.0)
#  ticket                        :integer          default(0)
#  total                         :decimal(10, 2)   default(0.0)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  cash_opening_services_sale_id :bigint
#  payment_type_id               :bigint
#  user_id                       :bigint
#

class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  belongs_to :cash_opening_services_sale
  has_many :sale_products

  def self.total(sales)
    return nil if sales.blank?

    sales
      .map {|sale| sale.total }
      .sum
  end

  def self.earnings_by_product(sales)
    earning = 0.0
    sales.each do |sale|
      earning += sale.sale_products.inject(0) { |sum, sale_product| sum + sale_product.earning }
    end
    earning
  end
end
