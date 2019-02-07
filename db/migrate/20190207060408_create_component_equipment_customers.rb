class CreateComponentEquipmentCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :component_equipment_customers do |t|
      t.references :component, foreign_key: true
      t.references :equipment_customer, foreign_key: true

      t.timestamps
    end
  end
end
