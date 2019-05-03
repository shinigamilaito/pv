class CashOpeningServicesSale < ApplicationRecord
  belongs_to :user
  has_many :payments
  has_many :sales

  validates :type_cash, :open_date, :user_id, presence: true
	validates :amount, presence: true

  def total_effective
    total_effective_sales + total_effective_services
  end

	def total_debit
    total_debit_sales + total_debit_services
  end

	def total_credit
    total_credit_sales + total_credit_services
  end

  private

  def total_effective_sales
    CashOpeningServicesSale
      .joins(sales: :payment_type)
      .where("cash_opening_services_sales.id = ? AND payment_types.name = ?", self.id, 'Efectivo')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

  def total_effective_services
    Payment
      .joins(:cash_opening_services_sale, :payment_type)
      .where("payment_types.name = ? AND payments.cash_opening_services_sale_id = ?", 'Efectivo', self.id)
      .map { |payment| payment.cost }
      .sum
  end

  def total_debit_sales
    CashOpeningServicesSale
      .joins(sales: :payment_type)
      .where("cash_opening_services_sales.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Debito')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

  def total_debit_services
    Payment
      .joins(:cash_opening_services_sale, :payment_type)
      .where("payment_types.name = ? AND payments.cash_opening_services_sale_id = ?", 'Tarjeta de Debito', self.id)
      .map { |payment| payment.cost }
      .sum
  end

  def total_credit_sales
    CashOpeningServicesSale
      .joins(sales: :payment_type)
      .where("cash_opening_services_sales.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Crédito')
      .select("sales.total as total")
      .map(&:total)
      .sum
  end

  def total_credit_services
    Payment
      .joins(:cash_opening_services_sale, :payment_type)
      .where("payment_types.name = ? AND payments.cash_opening_services_sale_id = ?", 'Tarjeta de Crédito', self.id)
      .map { |payment| payment.cost }
      .sum
  end
end
