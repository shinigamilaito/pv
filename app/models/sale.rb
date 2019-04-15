class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  belongs_to :cash_opening_sale
  has_many :sale_products

  def self.total(sales)
    return nil if sales.blank?

    sales
      .map {|sale| sale.total }
      .sum
  end
end
