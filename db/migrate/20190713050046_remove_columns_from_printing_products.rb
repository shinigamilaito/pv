class RemoveColumnsFromPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :printing_products, :sale_price, :string
    remove_column :printing_products, :sale_unit, :string
    add_column :printing_products, :piece, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :package, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :box, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :meter, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :roll, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :bag, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :set, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :printing_products, :increase_stock, :integer, default: 0
  end
end
