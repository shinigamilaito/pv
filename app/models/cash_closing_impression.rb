# == Schema Information
#
# Table name: cash_closing_impressions
#
#  id                         :bigint           not null, primary key
#  type_cash                  :string
#  close_date                 :datetime
#  user_id                    :bigint
#  total_effective            :decimal(, )
#  total_debit_card           :decimal(, )
#  total_credit_card          :decimal(, )
#  total_sales                :decimal(, )
#  open_amount                :decimal(, )
#  total                      :decimal(, )
#  cash_opening_impression_id :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class CashClosingImpression < ApplicationRecord
  belongs_to :user
  belongs_to :cash_opening_impression
end
