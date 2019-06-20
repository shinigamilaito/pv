class AddTicketToQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    add_column :quotation_printings, :ticket, :integer, default: 0
  end
end
