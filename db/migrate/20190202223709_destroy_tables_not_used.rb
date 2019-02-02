class DestroyTablesNotUsed < ActiveRecord::Migration[5.1]
  def change
    drop_table :support_spare_parts
    drop_table :supports
  end
end
