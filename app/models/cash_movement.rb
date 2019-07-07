# == Schema Information
#
# Table name: cash_movements
#
#  id              :bigint           not null, primary key
#  cash_type       :string
#  cash_id         :bigint
#  user_id         :bigint
#  amount          :decimal(10, 2)   default(0.0)
#  type_movement   :string
#  reason          :string
#  payment_type_id :bigint
#  comments        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CashMovement < ApplicationRecord
  belongs_to :cash, polymorphic: true
  belongs_to :user
  belongs_to :payment_type

  validates :cash, :user, :amount, :type_movement, presence: true
  validates :payment_type_id, presence: true
end
