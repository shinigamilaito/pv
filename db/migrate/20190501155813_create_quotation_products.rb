class CreateQuotationProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :quotation_products do |t|
      t.string :code
      t.string :name
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2, default: "0.0"
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
      t.references :quotation, foreign_key: true
      t.decimal :discount, precision: 10, scale: 2, default: "0.0"
      t.decimal :real_price, precision: 20, scale: 14, default: "0.0"

      t.timestamps
    end
  end
end
