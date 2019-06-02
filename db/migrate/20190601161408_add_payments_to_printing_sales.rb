class AddPaymentsToPrintingSales < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_sales, :full_payment, :boolean
    add_column :printing_sales, :payment, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
