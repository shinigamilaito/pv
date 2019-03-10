class AddPaymentTypeToSales < ActiveRecord::Migration[5.1]
  def change
    add_reference :sales, :payment_type, foreign_key: true
  end
end
