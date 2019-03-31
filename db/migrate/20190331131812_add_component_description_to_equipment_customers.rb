class AddComponentDescriptionToEquipmentCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :equipment_customers, :component_description, :text
  end
end
