class AddDiscountToSaleProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :sale_products, :discount, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
