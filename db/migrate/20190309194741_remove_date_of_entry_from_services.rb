class RemoveDateOfEntryFromServices < ActiveRecord::Migration[5.1]
  def change
    remove_column :services, :date_of_entry, :string
  end
end
