class RemoveColumnsFromServices < ActiveRecord::Migration[5.1]
  def change
    remove_column(:services, :payment_type_id)
    remove_column(:services, :worforce)
    remove_column(:services, :discount)
    remove_column(:services, :departure_date)
    remove_column(:services, :employee_id)
    remove_column(:services, :generic_price_id)
    remove_column(:services, :paid_with)
    remove_column(:services, :change)
    remove_column(:services, :total_tickets)
  end
end
