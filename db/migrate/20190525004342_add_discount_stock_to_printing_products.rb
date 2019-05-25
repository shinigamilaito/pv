class AddDiscountStockToPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_products, :discount_stock, :integer, default: "0"
  end
end
