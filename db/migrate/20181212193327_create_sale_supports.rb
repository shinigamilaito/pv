class CreateSaleSupports < ActiveRecord::Migration[5.1]
  def change
    create_table :sale_supports do |t|
      t.references :equipment_customer, foreign_key: true

      t.timestamps
    end
  end
end
