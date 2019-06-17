class CashPolicy

  def initialize
  end

  def cash_services_sales
    return CashOpeningServicesSale.find_by(active: true)
  end

  def cash_impressions
    return CashOpeningImpression.find_by(active: true)
  end

  def incomes_services_sales(cash)
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

  def totals_services_sales(cash)
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

  # Used by cash impressions
  def incomes_impressions(cash)
    partial_sales = cash.partial_sales
    printing_sales_total = cash.printing_sales.where(full_payment: true)
    printing_sales_parcial = cash.printing_sales.where(full_payment: false)
    quotation_printings = cash.quotation_printings
    incomes = []

    partial_sales.each do |partial_sale|
      income = {}
      income[:charged_date] = partial_sale.updated_at
      income[:folio_ticket] = partial_sale.printing_sale.ticket
      income[:charged_by] = partial_sale.user.formal_name
      income[:client] = partial_sale.printing_sale.client.formal_name
      income[:amount] = partial_sale.payment # Pago por un solo servicio
      income[:concept] = "Ventas Parciales"

      incomes << income
    end

    printing_sales_total.each do |printing_sale|
      income = {}
      income[:charged_date] = printing_sale.updated_at
      income[:folio_ticket] = printing_sale.ticket
      income[:charged_by] = printing_sale.user.formal_name
      income[:client] = "N/A"
      income[:amount] = printing_sale.total
      income[:concept] = "Ventas de Impresión"

      incomes << income
    end

    printing_sales_parcial.each do |printing_sale|
      income = {}
      income[:charged_date] = printing_sale.updated_at
      income[:folio_ticket] = printing_sale.ticket
      income[:charged_by] = printing_sale.user.formal_name
      income[:client] = printing_sale.client.formal_name
      income[:amount] = printing_sale.payment
      income[:concept] = "Ventas de Impresión"

      incomes << income
    end

    quotation_printings.each do |quotation_printing|
      income = {}
      income[:charged_date] = quotation_printing.updated_at
      income[:folio_ticket] = quotation_printing.number_folio
      income[:charged_by] = quotation_printing.user.formal_name
      income[:client] = quotation_printing.client.formal_name
      income[:amount] = quotation_printing.payment
      income[:concept] = "Ordenes de Trabajo"

      incomes << income
    end

    return incomes

  end

  def totals_impressions(cash)
    partial_sales = cash.partial_sales
    printing_sales_complet = cash.printing_sales.where(full_payment: true)
    printing_sales_parcial = cash.printing_sales.where(full_payment: false)
    quotation_printings = cash.quotation_printings

    total_partial_sales = PartialSale.total(partial_sales) || BigDecimal.new("0")
    total_printing_sales_complet = PrintingSale.total(printing_sales_complet) || BigDecimal.new("0")
    total_printing_sales_parcial = PrintingSale.parcial(printing_sales_parcial) || BigDecimal.new("0")
    total_quotation_printings = QuotationPrinting.total(quotation_printings) || BigDecimal.new("0")

    return total_partial_sales + total_printing_sales_complet + total_printing_sales_parcial + total_quotation_printings
  end

end
