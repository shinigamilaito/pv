class AddPurchasePricesToSales < ActiveRecord::Migration[5.1]
  def change
    add_column :sale_products, :purchase_price, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_sale_products, :purchase_price, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
