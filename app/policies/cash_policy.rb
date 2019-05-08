class CashPolicy

  def initialize
  end

  def cash_services_sales
    return CashOpeningServicesSale.find_by(active: true)
  end

  def cash_impressions
    return nil
  end

  def incomes(cash)
    payments = cash.payments
    sales = cash.sales
    incomes = []

    payments.each do |payment|
      income = {}
      income[:charged_date] = payment.updated_at
      income[:folio_ticket] = payment.service.number_folio
      income[:charged_by] = payment.user.formal_name
      income[:client] = payment.service.client.formal_name
      income[:amount] = totals_by_payment(payment)[:total_final] # Pago por un solo servicio
      income[:concept] = "Servicios"

      incomes << income
    end

    sales.each do |sale|
      income = {}
      income[:charged_date] = sale.updated_at
      income[:folio_ticket] = sale.ticket
      income[:charged_by] = sale.user.formal_name
      income[:client] = "N/A"
      income[:amount] = sale.total
      income[:concept] = "Ventas"

      incomes << income
    end

    return incomes
  end

  def totals(cash)
    payments = cash.payments
    sales = cash.sales

    total_payments = Payment.total(payments) || BigDecimal.new("0")
    total_sales = Sale.total(sales) || BigDecimal.new("0")

    return total_payments + total_sales
  end

  def totals_by_payment(income)
    total_calculator = TotalCalculator.new(income.service, income)
    total_calculator.worforce = income.real_worforce
    total_calculator.discount = income.discount
    total_calculator.totals
  end

end
