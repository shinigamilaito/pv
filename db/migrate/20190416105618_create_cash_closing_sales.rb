class CreateCashClosingSales < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_closing_sales do |t|
      t.string :type_cash, default: "sales"
      t.datetime :close_date
      t.references :user, foreign_key: true
      t.decimal :total_effective, precision: 10, scale: 2, default: "0.0"
      t.decimal :total_debit_card, precision: 10, scale: 2, default: "0.0"
      t.decimal :total_credit_card, precision: 10, scale: 2, default: "0.0"
      t.decimal :total_sales, precision: 10, scale: 2, default: "0.0"
      t.decimal :open_amount, precision: 10, scale: 2, default: "0.0"
      t.decimal :total, precision: 10, scale: 2, default: "0.0"
      t.references :cash_opening_sale, foreign_key: true

      t.timestamps
    end
  end
end
