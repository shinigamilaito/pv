class CashOpeningService < ApplicationRecord
	belongs_to :user
	has_many :payments

	validates :type_cash, :open_date, :user_id, presence: true
	validates :amount, presence: true

  def total_effective
    Payment
      .joins(:cash_opening_service, :payment_type)
      .where("payment_types.name = ? AND payments.cash_opening_service_id = ?", 'Efectivo', self.id)
      .map { |payment| payment.cost }
      .sum
  end

	def total_debit
    Payment
      .joins(:cash_opening_service, :payment_type)
      .where("payment_types.name = ? AND payments.cash_opening_service_id = ?", 'Tarjeta de Debito', self.id)
      .map { |payment| payment.cost }
      .sum
  end

	def total_credit
    Payment
      .joins(:cash_opening_service, :payment_type)
      .where("payment_types.name = ? AND payments.cash_opening_service_id = ?", 'Tarjeta de Crédito', self.id)
      .map { |payment| payment.cost }
      .sum
  end
end
