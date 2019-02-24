class AddPaidWithAndChangeToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :paid_with, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :services, :change, :decimal, precision: 10, scale: 2, default: "0.0"
  end
end
