class CreateSpareParts < ActiveRecord::Migration[5.1]
  def change
    create_table :spare_parts do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :total

      t.timestamps
    end
  end
end
