class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :address

      t.timestamps
    end
  end
end
