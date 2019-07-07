# == Schema Information
#
# Table name: cash_opening_impressions
#
#  id         :bigint           not null, primary key
#  type_cash  :string
#  open_date  :datetime
#  user_id    :bigint
#  amount     :decimal(, )
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CashOpeningImpression < ApplicationRecord
  belongs_to :user
  has_many :printing_sales
  has_many :partial_sales
  has_many :quotation_printings

  validates :type_cash, :open_date, :user_id, presence: true
  validates :amount, presence: true

  def total_effective
    total_effective_partial_printing_sales + total_effective_full_printing_sales +
    total_effective_partial_sales + total_effective_quotation_printings
  end

  def total_debit
    total_debit_partial_printing_sales + total_debit_full_printing_sales +
    total_debit_partial_sales + total_debit_quotation_printings
  end

  def total_credit
    total_credit_partial_printing_sales + total_credit_full_printing_sales +
    total_credit_partial_sales + total_credit_quotation_printings
  end

  private

  # Efectivo
  def total_effective_partial_printing_sales
    PrintingSale
    .joins(:payment_type, :cash_opening_impression)
    .where("printing_sales.full_payment = ? AND cash_opening_impressions.id = ? AND payment_types.name = ?", false, self.id, 'Efectivo')
    .select("printing_sales.payment as total")
    .map(&:total)
    .sum
  end

  def total_effective_full_printing_sales
    PrintingSale
    .joins(:payment_type, :cash_opening_impression)
    .where("printing_sales.full_payment = ? AND cash_opening_impressions.id = ? AND payment_types.name = ?", true, self.id, 'Efectivo')
    .select("printing_sales.total as total")
    .map(&:total)
    .sum
  end

  def total_effective_partial_sales
    PartialSale
    .joins(:payment_type, :cash_opening_impression)
    .where("cash_opening_impressions.id = ? AND payment_types.name = ?", self.id, 'Efectivo')
    .select("partial_sales.payment as total")
    .map(&:total)
    .sum
  end

  def total_effective_quotation_printings
    QuotationPrinting
    .joins(:payment_type, :cash_opening_impression)
    .where("cash_opening_impressions.id = ? AND payment_types.name = ?", self.id, 'Efectivo')
    .select("quotation_printings.payment as total")
    .map(&:total)
    .sum
  end

  # Debito
  def total_debit_partial_printing_sales
    PrintingSale
    .joins(:payment_type, :cash_opening_impression)
    .where("printing_sales.full_payment = ? AND cash_opening_impressions.id = ? AND payment_types.name = ?", false, self.id, 'Tarjeta de Debito')
    .select("printing_sales.payment as total")
    .map(&:total)
    .sum
  end

  def total_debit_full_printing_sales
    PrintingSale
    .joins(:payment_type, :cash_opening_impression)
    .where("printing_sales.full_payment = ? AND cash_opening_impressions.id = ? AND payment_types.name = ?", true, self.id, 'Tarjeta de Debito')
    .select("printing_sales.total as total")
    .map(&:total)
    .sum
  end

  def total_debit_partial_sales
    PartialSale
    .joins(:payment_type, :cash_opening_impression)
    .where("cash_opening_impressions.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Debito')
    .select("partial_sales.payment as total")
    .map(&:total)
    .sum
  end

  def total_debit_quotation_printings
    QuotationPrinting
    .joins(:payment_type, :cash_opening_impression)
    .where("cash_opening_impressions.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Debito')
    .select("quotation_printings.payment as total")
    .map(&:total)
    .sum
  end

  # Credito
  def total_credit_partial_printing_sales
    PrintingSale
    .joins(:payment_type, :cash_opening_impression)
    .where("printing_sales.full_payment = ? AND cash_opening_impressions.id = ? AND payment_types.name = ?", false, self.id, 'Tarjeta de Crédito')
    .select("printing_sales.payment as total")
    .map(&:total)
    .sum
  end

  def total_credit_full_printing_sales
    PrintingSale
    .joins(:payment_type, :cash_opening_impression)
    .where("printing_sales.full_payment = ? AND cash_opening_impressions.id = ? AND payment_types.name = ?", true, self.id, 'Tarjeta de Crédito')
    .select("printing_sales.total as total")
    .map(&:total)
    .sum
  end

  def total_credit_partial_sales
    PartialSale
    .joins(:payment_type, :cash_opening_impression)
    .where("cash_opening_impressions.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Crédito')
    .select("partial_sales.payment as total")
    .map(&:total)
    .sum
  end

  def total_credit_quotation_printings
    QuotationPrinting
    .joins(:payment_type, :cash_opening_impression)
    .where("cash_opening_impressions.id = ? AND payment_types.name = ?", self.id, 'Tarjeta de Crédito')
    .select("quotation_printings.payment as total")
    .map(&:total)
    .sum
  end


end
