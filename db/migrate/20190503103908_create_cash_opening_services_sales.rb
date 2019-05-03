class CreateCashOpeningServicesSales < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_opening_services_sales do |t|
      t.string :type_cash, default: "services_sales"
      t.datetime :open_date
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: "0.0"
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
