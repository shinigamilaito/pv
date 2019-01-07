class RemoveColumnsFromEquipmentCustomers < ActiveRecord::Migration[5.1]
  def change
  	remove_column :equipment_customers, :client_id, :references
  	remove_column :equipment_customers, :folio, :string
  end
end
