class CreateSaleProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :sale_products do |t|
      t.string :code
      t.string :name
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2, default: "0.0"
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
      t.references :sale, foreign_key: true

      t.timestamps
    end
  end
end
