class AddImageClientToSupports < ActiveRecord::Migration[5.1]
  def change
    add_column :supports, :image_client, :string
  end
end
