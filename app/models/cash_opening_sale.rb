class CashOpeningSale < ApplicationRecord
  belongs_to :user

  has_many :sales

  validates :type_cash, :open_date, :user_id, presence: true
	validates :amount, presence: true

  def total_effective
    CashOpeningSale
      .joins(sales: :payment_type)
      .where("cash_opening_sales.id = ? AND payment_types.name = ?", self.id, 'Efectivo')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

  def total_debit
    CashOpeningSale
      .joins(sales: :payment_type)
      .where("cash_opening_sales.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Debito')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

	def total_credit
    CashOpeningSale
      .joins(sales: :payment_type)
      .where("cash_opening_sales.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Crédito')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end
end
