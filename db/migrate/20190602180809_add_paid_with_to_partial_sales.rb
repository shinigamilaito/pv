class AddPaidWithToPartialSales < ActiveRecord::Migration[5.1]
  def change
    add_column :partial_sales, :paid_with, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
