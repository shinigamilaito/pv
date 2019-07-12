class CreateContentForInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :content_for_invitations do |t|
      t.references :category, foreign_key: true
      t.references :subcategory, foreign_key: true
      t.string :name
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end
