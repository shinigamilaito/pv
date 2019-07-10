class AddExtraFieldsToPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_products, :purchase_unit, :string
    add_column :printing_products, :content, :integer
    add_column :printing_products, :utility, :decimal
    remove_column :printing_products, :contains, :integer
    remove_column :printing_products, :contain_unit, :string
    remove_column :printing_products, :discount_stock, :string
  end
end
