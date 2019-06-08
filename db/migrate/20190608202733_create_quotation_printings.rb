class CreateQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    create_table :quotation_printings do |t|
      t.references :invitation, foreign_key: true
      t.references :client, foreign_key: true
      t.decimal :cost_piece, precision: 10, scale: 2, default: "0.0"
      t.integer :total_pieces
      t.decimal :cost_elaboration, precision: 10, scale: 2, default: "0.0"
      t.decimal :total_quotations, precision: 10, scale: 2, default: "0.0"
      t.decimal :total_cost, precision: 10, scale: 2, default: "0.0"
      t.decimal :utility, precision: 10, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
