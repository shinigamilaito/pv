class CreatePrintingProductQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    create_table :printing_product_quotation_printings do |t|
      t.references :printing_product, index: { name: "index_p_p_q_p_on_printing_product_id" }, foreign_key: true
      t.references :quotation_printing, index: { name: "index_p_p_q_p_on_quotation_printing_id" }, foreign_key: true
      t.integer :quantity, default: "0.0"

      t.timestamps
    end
  end
end
