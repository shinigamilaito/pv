# Record printing sales, the products are obtained from
# printing products catalogs

# == Schema Information
#
# Table name: printing_sales
#
#  id                         :bigint           not null, primary key
#  user_id                    :bigint
#  subtotal                   :decimal(10, 2)   default(0.0)
#  discount                   :decimal(10, 2)   default(0.0)
#  total                      :decimal(10, 2)   default(0.0)
#  paid_with                  :decimal(10, 2)   default(0.0)
#  change                     :decimal(10, 2)   default(0.0)
#  ticket                     :integer          default(0)
#  payment_type_id            :bigint
#  client_id                  :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  total_paid                 :boolean          default(TRUE)
#  difference                 :decimal(10, 2)   default(0.0)
#  full_payment               :boolean
#  payment                    :decimal(10, 2)   default(0.0)
#  cash_opening_impression_id :bigint
#

class PrintingSale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  belongs_to :client, optional: true
  belongs_to :cash_opening_impression

  has_many :printing_sale_products
  has_many :partial_sales

  def self.total(printing_sales_complet)
    return nil if printing_sales_complet.blank?

    printing_sales_complet.map(&:total).sum
  end

  def self.parcial(printing_sales_parcial)
    return nil if printing_sales_parcial.blank?

    printing_sales_parcial.map(&:payment).sum
  end

  def self.earnings_by_product(sales)
    earning = 0.0
    sales.each do |sale|
      earning += sale.printing_sale_products.inject(0) { |sum, sale_product| sum + sale_product.earning }
    end
    earning
  end

  def total_parcial_payments
    if self.full_payment
      BigDecimal.new(0.00, 2)
    else
      PartialSale.total(self.partial_sales)
    end
  end
end
