class CreateMessageHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :message_histories do |t|
      t.text :message
      t.references :equipment_customer, foreign_key: true

      t.timestamps
    end
  end
end
