class RemoveUtilityFrom < ActiveRecord::Migration[5.1]
  def change
    remove_column :printing_products, :utility, :string
  end
end
