class AddServiceReferencesToEquipmentCustomer < ActiveRecord::Migration[5.1]
  def change
    add_reference :equipment_customers, :service, foreign_key: true
  end
end
