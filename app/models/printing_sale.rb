class PrintingSale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  belongs_to :client, optional: true
  belongs_to :cash_opening_impression

  has_many :printing_sale_products
  has_many :partial_sales

  def self.total(printing_sales_complet)
    return nil if printing_sales_complet.blank?

    printing_sales_complet
      .map {|printing_sale_complet| printing_sale_complet.total }
      .sum
  end

  def self.parcial(printing_sales_parcial)
    return nil if printing_sales_parcial.blank?

    printing_sales_parcial
      .map {|printing_sale_parcial| printing_sale_parcial.payment }
      .sum
  end
end
