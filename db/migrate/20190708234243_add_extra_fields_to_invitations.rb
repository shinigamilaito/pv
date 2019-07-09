class AddExtraFieldsToInvitations < ActiveRecord::Migration[5.1]
  def change
    add_reference :invitations, :category, foreign_key: true
    add_reference :invitations, :subcategory, foreign_key: true
    add_column :invitations, :description, :text
    remove_column :invitations, :created_in_quotation, type: :boolean
  end
end
