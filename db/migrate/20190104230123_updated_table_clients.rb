class UpdatedTableClients < ActiveRecord::Migration[5.1]
  def change
  	remove_column :clients, :address, :string
  	add_column :clients, :address, :text
  	add_column :clients, :mobile_phone, :string
  	add_column :clients, :home_phone, :string 
  end
end
