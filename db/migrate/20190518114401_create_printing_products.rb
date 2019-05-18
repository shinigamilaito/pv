class CreatePrintingProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :printing_products do |t|
      t.string :code
      t.string :name
      t.decimal :purchase_price, precision: 10, scale: 2, default: "0.0"
      t.decimal :sale_price, precision: 10, scale: 2, default: "0.0"
      t.string :sale_unit
      t.integer :stock
      t.integer :contains
      t.string :contain_unit

      t.timestamps
    end
  end
end
