class ChangeControlNumberToStringInServiceSpareParts < ActiveRecord::Migration[5.1]
  def change
    change_column :service_spare_parts, :control_number, :string
  end
end
