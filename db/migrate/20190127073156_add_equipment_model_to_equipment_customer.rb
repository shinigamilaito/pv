class AddEquipmentModelToEquipmentCustomer < ActiveRecord::Migration[5.1]
  def change
    add_reference :equipment_customers, :equipment_model, foreign_key: true
  end
end
