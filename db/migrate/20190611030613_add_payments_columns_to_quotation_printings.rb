class AddPaymentsColumnsToQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    add_column :quotation_printings, :paid_with, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :quotation_printings, :payment, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :quotation_printings, :change, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :quotation_printings, :difference, :decimal, precision: 10, scale: 2, default: "0.0"
    add_reference :quotation_printings, :payment_type, foreign_key: true
    add_column :quotation_printings, :full_payment, :boolean
  end
end
