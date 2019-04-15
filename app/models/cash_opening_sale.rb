class CashOpeningSale < ApplicationRecord
  belongs_to :user

  has_many :sales

  validates :type_cash, :open_date, :user_id, presence: true
	validates :amount, :active, presence: true

  def total_effective
    CashOpeningSale
      .joins(sales: :payment_type)
      .where("payment_types.name = ?", 'Efectivo')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

  def total_debit
    CashOpeningSale
      .joins(sales: :payment_type)
      .where("payment_types.name = ?", 'Tarjeta de Debito')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

	def total_credit
    CashOpeningSale
      .joins(sales: :payment_type)
      .where("payment_types.name = ?", 'Tarjeta de Crédito')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end
end
