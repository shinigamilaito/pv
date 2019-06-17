class PartialSale < ApplicationRecord
  belongs_to :printing_sale
  belongs_to :payment_type
  belongs_to :user
  belongs_to :cash_opening_impression

  def self.total(partial_sales)
    return nil if partial_sales.blank?

    partial_sales
      .map {|partial_sale| partial_sale.payment }
      .sum
  end
end
