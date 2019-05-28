class AddTotalPaidAndDifferenceToPrintingSales < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_sales, :total_paid, :boolean, default: true
    add_column :printing_sales, :difference, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
