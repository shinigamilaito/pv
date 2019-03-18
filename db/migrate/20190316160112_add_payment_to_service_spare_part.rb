class AddPaymentToServiceSparePart < ActiveRecord::Migration[5.1]
  def change
    add_reference :service_spare_parts, :payment, foreign_key: true
  end
end
