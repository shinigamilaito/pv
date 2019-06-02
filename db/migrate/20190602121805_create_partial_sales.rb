class CreatePartialSales < ActiveRecord::Migration[5.1]
  def change
    create_table :partial_sales do |t|
      t.references :printing_sale, foreign_key: true
      t.decimal :payment, precision: 10, scale: 2, default: "0.0"
      t.decimal :difference, precision: 10, scale: 2, default: "0.0"
      t.references :payment_type, foreign_key: true
      t.decimal :change, precision: 10, scale: 2, default: "0.0"
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
