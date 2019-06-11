class AddNumberFolioAndStatusToQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    add_column :quotation_printings, :number_folio, :string
    add_column :quotation_printings, :status, :string
  end
end
