class CreateEquipmentCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :equipment_customers do |t|
      t.references :client, foreign_key: true
      t.string :folio
      t.references :equipment, foreign_key: true
      t.references :brand, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
