# == Schema Information
#
# Table name: sales
#
#  id                            :bigint           not null, primary key
#  user_id                       :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  subtotal                      :decimal(10, 2)   default(0.0)
#  discount                      :decimal(10, 2)   default(0.0)
#  total                         :decimal(10, 2)   default(0.0)
#  paid_with                     :decimal(10, 2)   default(0.0)
#  change                        :decimal(10, 2)   default(0.0)
#  ticket                        :integer          default(0)
#  payment_type_id               :bigint
#  cash_opening_services_sale_id :bigint
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
end
