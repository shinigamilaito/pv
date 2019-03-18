class AddPaymentToEquipmentCustomer < ActiveRecord::Migration[5.1]
  def change
    add_reference :equipment_customers, :payment, foreign_key: true
  end
end
