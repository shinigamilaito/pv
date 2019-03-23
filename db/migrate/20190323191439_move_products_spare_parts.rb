class MoveProductsSpareParts < ActiveRecord::Migration[5.1]
  def change
    remove_column(:spare_parts, :control_number)
    add_column(:spare_parts, :code, :string)
    add_column(:products, :description, :text)
  end
end
