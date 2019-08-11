class CreateMessageHistoryQuotationPrintings < ActiveRecord::Migration[5.1]
  def change
    create_table :message_history_quotation_printings do |t|
      t.text :message
      t.references :quotation_printing, index: { name: "index_m_h_q_p_on_quotation_printing_id" }, foreign_key: true
      t.references :user, index: { name: "index_m_h_q_p_on_user_id" }, foreign_key: true

      t.timestamps
    end
  end
end
