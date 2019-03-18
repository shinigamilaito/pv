class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :payment_type, foreign_key: true
      t.decimal :worforce, precision: 10, scale: 2, default: "0.0"
      t.decimal :discount, precision: 10, scale: 2, default: "0.0"
      t.string :departure_date
      t.references :user, foreign_key: true
      t.references :generic_price, foreign_key: true
      t.decimal :paid_with, precision: 10, scale: 2, default: "0.0"
      t.decimal :change, precision: 10, scale: 2, default: "0.0"
      t.integer :ticket, default: 0
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
