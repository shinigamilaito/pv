class AddImagenToInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :invitations, :imagen, :string
  end
end
