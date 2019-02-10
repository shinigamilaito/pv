class SaleProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  def self.new_from(product)
    sale_product = SaleProduct.new
    sale_product.code = product.code
    sale_product.name = product.name
    sale_product.quantity = 1
    sale_product.price = product.price
    sale_product.product = product

    sale_product
  end

  def adjust_quantity(new_quantity)
    self.quantity += new_quantity
    self.save
  end
end
