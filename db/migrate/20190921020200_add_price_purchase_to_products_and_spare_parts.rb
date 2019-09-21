class AddPricePurchaseToProductsAndSpareParts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :price_purchase, :decimal, precision: 10, scale: 2
    add_column :spare_parts, :price_purchase, :decimal, precision: 10, scale: 2
  end
end
