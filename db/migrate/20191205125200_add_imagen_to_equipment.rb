class AddImagenToEquipment < ActiveRecord::Migration[5.1]
  def change
    add_column :equipments, :imagen, :string
  end
end
