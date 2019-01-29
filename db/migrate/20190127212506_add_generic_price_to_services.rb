class AddGenericPriceToServices < ActiveRecord::Migration[5.1]
  def change
    add_reference :services, :generic_price, foreign_key: true
  end
end
