class ChangeDateColumnsOfQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    change_column :quotation_printings, :delivery_date, :string
    change_column :quotation_printings, :draft_delivery_date, :string
  end
end
