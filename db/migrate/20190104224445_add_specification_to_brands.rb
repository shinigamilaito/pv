class AddSpecificationToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :specifications, :text
  end
end
