class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
