class AddRealPriceToSaleProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :sale_products, :real_price, :decimal, precision: 20, scale: 10, default: "0.0"
  end
end
