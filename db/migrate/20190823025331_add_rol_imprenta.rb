class AddRolImprenta < ActiveRecord::Migration[5.1]
  def up
    Rol.create(name: "Imprenta")
  end

  def down
    Rol.find_by_name("Imprenta").destroy
  end
end
