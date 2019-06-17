class CreateCashClosingImpressions < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_closing_impressions do |t|
      t.string :type_cash
      t.datetime :close_date
      t.references :user, foreign_key: true
      t.decimal :total_effective
      t.decimal :total_debit_card
      t.decimal :total_credit_card
      t.decimal :total_sales
      t.decimal :open_amount
      t.decimal :total
      t.references :cash_opening_impression, foreign_key: true

      t.timestamps
    end
  end
end
