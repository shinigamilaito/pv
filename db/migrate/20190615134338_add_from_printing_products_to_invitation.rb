class AddFromPrintingProductsToInvitation < ActiveRecord::Migration[5.1]
  def change
    add_column :invitation_printing_products, :from_printing_products, :boolean, default: true
  end
end
