class AddExtraInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :address, :text
    add_column :users, :contact, :string
  end
end
