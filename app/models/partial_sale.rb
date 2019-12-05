# == Schema Information
#
# Table name: partial_sales
#
#  id                         :bigint           not null, primary key
#  printing_sale_id           :bigint
#  payment                    :decimal(10, 2)   default(0.0)
#  difference                 :decimal(10, 2)   default(0.0)
#  payment_type_id            :bigint
#  change                     :decimal(10, 2)   default(0.0)
#  user_id                    :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  paid_with                  :decimal(10, 2)   default(0.0)
#  cash_opening_impression_id :bigint
#

class PartialSale < ApplicationRecord
  belongs_to :printing_sale
  belongs_to :payment_type
  belongs_to :user
  belongs_to :cash_opening_impression

  def self.total(partial_sales)
    return BigDecimal.new("0.0") if partial_sales.blank?

    partial_sales
      .map {|partial_sale| partial_sale.payment }
      .sum
  end
end
