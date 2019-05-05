class CashMovement < ApplicationRecord
  belongs_to :cash, polymorphic: true
  belongs_to :user
  belongs_to :payment_type

  validates :cash, :user, :amount, :type_movement, presence: true
  validates :payment_type_id, presence: true
end
