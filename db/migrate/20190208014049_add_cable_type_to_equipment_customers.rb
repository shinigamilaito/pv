class AddCableTypeToEquipmentCustomers < ActiveRecord::Migration[5.1]
  def change
    add_reference :equipment_customers, :cable_type, foreign_key: true
  end
end
