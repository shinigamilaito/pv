class AddEquivalenciesStockPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_products, :package_stock, :integer, default: 0
    add_column :printing_products, :meter_stock, :integer, default: 0
    add_column :printing_products, :bag_stock, :integer, default: 0
    add_column :printing_products, :box_stock, :integer, default: 0
    add_column :printing_products, :set_stock, :integer, default: 0
    add_column :printing_products, :roll_stock, :integer, default: 0

    add_column :printing_sale_products, :real_sale_unit, :string
  end
end
