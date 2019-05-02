class CreateQuotations < ActiveRecord::Migration[5.1]
  def change
    create_table :quotations do |t|
      t.references :user, foreign_key: true
      t.decimal :total, precision: 20, scale: 14, default: "0.0"
      t.integer :folio, default: 0
      t.references :client, foreign_key: true
      t.string :status, default: "Vigente"

      t.timestamps
    end
  end
end
