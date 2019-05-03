class CashOpeningSale < ApplicationRecord
  belongs_to :user

  has_many :sales

  validates :type_cash, :open_date, :user_id, presence: true
	validates :amount, presence: true

  def total_effective

  end

  def total_debit

  end

	def total_credit

  end
end
