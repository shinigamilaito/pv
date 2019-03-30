class AddSerieNumberToEquipmentCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :equipment_customers, :serie_number, :string
  end
end
