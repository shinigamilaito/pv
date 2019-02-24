class AddTotalTicketsToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :total_tickets, :integer, default: "0"
  end
end
