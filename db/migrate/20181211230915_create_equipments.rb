class CreateEquipments < ActiveRecord::Migration[5.1]
  def change
    create_table :equipments do |t|
      t.string :name

      t.timestamps
    end
  end
end
