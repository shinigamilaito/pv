class CreateCashOpeningImpressions < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_opening_impressions do |t|
      t.string :type_cash
      t.datetime :open_date
      t.references :user, foreign_key: true
      t.decimal :amount
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
