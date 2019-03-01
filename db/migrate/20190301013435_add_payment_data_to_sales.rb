class AddPaymentDataToSales < ActiveRecord::Migration[5.1]
  def change
    add_column :sales, :subtotal, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :sales, :discount, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :sales, :total, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :sales, :paid_with, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :sales, :change, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
