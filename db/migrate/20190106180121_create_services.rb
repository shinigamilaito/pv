class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.references :client, foreign_key: true
      t.string :folio
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
