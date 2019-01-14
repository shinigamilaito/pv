class CreateServiceSpareParts < ActiveRecord::Migration[5.1]
  def change
    create_table :service_spare_parts do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
