class CreateInvitationPrintingProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :invitation_printing_products do |t|
      t.references :user, foreign_key: true
      t.references :invitation, foreign_key: true
      t.references :printing_product, foreign_key: true

      t.timestamps
    end
  end
end
