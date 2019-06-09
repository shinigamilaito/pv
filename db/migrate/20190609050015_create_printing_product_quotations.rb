class CreatePrintingProductQuotations < ActiveRecord::Migration[5.1]
  def change
    create_table :printing_product_quotations do |t|
      t.references :invitation_printing_product,  index: { name: "invitation_printing_product" }, foreign_key: true
      t.references :quotation_printing, foreign_key: true
      t.references :user, foreign_key: true
      t.string :code
      t.string :name
      t.decimal :quantity, precision: 10, scale: 2, default: "0.0"
      t.decimal :purchase_price, precision: 10, scale: 2, default: "0.0"
      t.decimal :real_price, precision: 20, scale: 10, default: "0.0"
      t.decimal :total, precision: 10, scale: 2, default: "0.0"
      t.string :sale_unit

      t.timestamps
    end
  end
end
