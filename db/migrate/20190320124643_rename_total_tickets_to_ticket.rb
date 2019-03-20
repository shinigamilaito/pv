class RenameTotalTicketsToTicket < ActiveRecord::Migration[5.1]
  def change
    rename_column :sales, :total_tickets, :ticket
  end
end
