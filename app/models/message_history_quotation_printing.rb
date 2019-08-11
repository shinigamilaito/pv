# == Schema Information
#
# Table name: message_history_quotation_printings
#
#  id                    :bigint           not null, primary key
#  message               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  quotation_printing_id :bigint
#  user_id               :bigint
#

class MessageHistoryQuotationPrinting < ApplicationRecord
  belongs_to :quotation_printing
  belongs_to :user
end
