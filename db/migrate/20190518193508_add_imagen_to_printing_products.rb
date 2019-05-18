class AddImagenToPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_products, :imagen, :string
  end
end
