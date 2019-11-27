class AddImagenToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :imagen, :string
  end
end
