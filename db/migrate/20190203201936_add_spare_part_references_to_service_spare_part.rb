class AddSparePartReferencesToServiceSparePart < ActiveRecord::Migration[5.1]
  def change
    add_reference :service_spare_parts, :spare_part, foreign_key: true
  end
end
