class AddTotalTicketsToSales < ActiveRecord::Migration[5.1]
  def change
    add_column :sales, :total_tickets, :integer, default: '0'
  end
end
