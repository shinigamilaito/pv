class AddStockMinimoToProductsAndSpareParts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :stock_minimum, :integer, default: "0"
    add_column :spare_parts, :stock_minimum, :integer, default: "0"
  end
end
