class AddImagenToQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    add_column :quotation_printings, :imagen, :string
  end
end
