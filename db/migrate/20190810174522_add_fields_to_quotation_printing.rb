class AddFieldsToQuotationPrinting < ActiveRecord::Migration[5.1]
  def change
    add_column :quotation_printings, :draft_delivery_date, :datetime
    add_column :quotation_printings, :delivery_date, :datetime
    add_column :quotation_printings, :printing_type, :string
    add_column :quotation_printings, :description, :text
    add_column :quotation_printings, :description_adjust_design, :text
    add_reference :quotation_printings, :content_for_invitation, foreign_key: true
  end
end
