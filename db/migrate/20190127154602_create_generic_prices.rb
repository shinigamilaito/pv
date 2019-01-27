class CreateGenericPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :generic_prices do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
