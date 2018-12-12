class CreateSupports < ActiveRecord::Migration[5.1]
  def change
    create_table :supports do |t|
      t.references :equipment_customer, foreign_key: true
      t.text :description
      t.string :date_of_entry
      t.references :payment_type, foreign_key: true
      t.references :client_type, foreign_key: true
      t.decimal :worforce, precision: 10, scale: 2
      t.decimal :discount,  precision: 10, scale: 2
      t.string :departure_date

      t.timestamps
    end
  end
end
