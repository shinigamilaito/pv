class AddCashToPaymentsAndSales < ActiveRecord::Migration[5.1]
  def change
    add_reference :payments, :cash_opening_service, foreign_key: true
    add_reference :sales, :cash_opening_sale, foreign_key: true
  end
end
