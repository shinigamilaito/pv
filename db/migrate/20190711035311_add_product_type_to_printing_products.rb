class AddProductTypeToPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_products, :product_type, :string
  end
end
