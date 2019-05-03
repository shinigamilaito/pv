class AddCashServicesSalesToPaymentsAndSales < ActiveRecord::Migration[5.1]
  def change
    add_reference :payments, :cash_opening_services_sale, foreign_key: true
    add_reference :sales, :cash_opening_services_sale, foreign_key: true

    remove_reference :payments, :cash_opening_service, index: true
    remove_reference :sales, :cash_opening_sale, index: true
  end
end
