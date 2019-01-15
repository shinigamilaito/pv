class AddPaidColumnsToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :date_of_entry, :string
    add_reference :services, :payment_type, foreign_key: true
    add_column :services, :worforce, :decimal, precision: 10, scale: 2, default: 0
    add_column :services, :discount, :decimal, precision: 10, scale: 2, default: 0
    add_column :services, :departure_date, :string
    add_column :services, :image_client, :string
    add_column :services, :paid, :boolean, default: false
  end
end
