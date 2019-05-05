class CreateCashMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :cash_movements do |t|
      t.references :cash, polymorphic: true
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: "0.0"
      t.string :type_movement
      t.string :reason
      t.references :payment_type, foreign_key: true
      t.string :comments

      t.timestamps
    end
  end
end
