class CreateCashOpeningService < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_opening_services do |t|
      t.string :type_cash, default: "servicios"
      t.datetime :open_date, default: DateTime.now
      t.references :user
      t.decimal :amount, precision: 10, scale: 2, default: "0.0"
      t.boolean :active, default: true
    end
  end
end
