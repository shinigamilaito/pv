class AddSaleUnitToPrintingSaleProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :printing_sale_products, :sale_unit, :string
  end
end
