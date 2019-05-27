class CreatePrintingSales < ActiveRecord::Migration[5.1]
  def change
    create_table :printing_sales do |t|
      t.references :user, foreign_key: true
      t.decimal :subtotal, precision: 10, scale: 2, default: "0.0"
      t.decimal :discount, precision: 10, scale: 2, default: "0.0"
      t.decimal :total, precision: 10, scale: 2, default: "0.0"
      t.decimal :paid_with, precision: 10, scale: 2, default: "0.0"
      t.decimal :change, precision: 10, scale: 2, default: "0.0"
      t.integer :ticket, default: 0
      t.references :payment_type, foreign_key: true
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
