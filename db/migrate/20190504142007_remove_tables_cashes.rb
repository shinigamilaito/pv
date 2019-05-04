class RemoveTablesCashes < ActiveRecord::Migration[5.1]
  def change
    drop_table :cash_closing_sales
    drop_table :cash_closing_services
    drop_table :cash_opening_sales
    drop_table :cash_opening_services
  end
end
