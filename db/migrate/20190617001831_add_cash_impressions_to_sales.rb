class AddCashImpressionsToSales < ActiveRecord::Migration[5.1]
  def change
    add_reference :printing_sales, :cash_opening_impression, foreign_key: true
    add_reference :partial_sales, :cash_opening_impression, foreign_key: true
    add_reference :quotation_printings, :cash_opening_impression, foreign_key: true
  end
end
