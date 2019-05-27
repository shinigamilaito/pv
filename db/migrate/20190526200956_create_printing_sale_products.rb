class CreatePrintingSaleProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :printing_sale_products do |t|
      t.string :code
      t.string :name
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2, default: "0.0"
      t.references :printing_product, foreign_key: true
      t.references :user, foreign_key: true
      t.references :printing_sale, foreign_key: true
      t.decimal :real_price, precision: 20, scale: 10, default: "0.0"

      t.timestamps
    end
  end
end
