class CreateCashOpeningSales < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_opening_sales do |t|
      t.string :type_cash, default: "sales"
      t.datetime :open_date, default: DateTime.now
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: "0.0"
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
