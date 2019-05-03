class CashOpeningService < ApplicationRecord
	belongs_to :user
	has_many :payments

	validates :type_cash, :open_date, :user_id, presence: true
	validates :amount, presence: true


end
