class AddUserToQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotation_printings, :user, foreign_key: true
  end
end
