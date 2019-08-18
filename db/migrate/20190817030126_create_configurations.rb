class CreateConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :configuration_data do |t|
      t.string :url_background_carousel

      t.timestamps
    end
  end
end
