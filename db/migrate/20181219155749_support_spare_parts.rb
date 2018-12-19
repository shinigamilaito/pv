class SupportSpareParts < ActiveRecord::Migration[5.1]
  def change
  	create_table :support_spare_parts do |t|
	  	t.string :name
	    t.text :description
	    t.decimal :price, precision: 10, scale: 2
	    t.integer :quantity
	    t.references :support, foreign_key: true

	    t.timestamps
	end
  end
end
