# == Schema Information
#
# Table name: cash_closing_services_sales
#
#  id                            :bigint           not null, primary key
#  type_cash                     :string           default("services_sales")
#  close_date                    :datetime
#  user_id                       :bigint
#  total_effective               :decimal(10, 2)   default(0.0)
#  total_debit_card              :decimal(10, 2)   default(0.0)
#  total_credit_card             :decimal(10, 2)   default(0.0)
#  total_sales                   :decimal(10, 2)   default(0.0)
#  open_amount                   :decimal(10, 2)   default(0.0)
#  total                         :decimal(10, 2)   default(0.0)
#  cash_opening_services_sale_id :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class CashClosingServicesSale < ApplicationRecord
  belongs_to :user
  belongs_to :cash_opening_services_sale
end
