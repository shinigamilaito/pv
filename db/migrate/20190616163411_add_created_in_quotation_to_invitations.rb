class AddCreatedInQuotationToInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :invitations, :created_in_quotation, :boolean, default: false
  end
end
