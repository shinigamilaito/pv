class CashCloseService
  attr_accessor :type_cash, :close_date, :employee

  # Create a new cash object
  def initialize(close_date, employee)
    @close_date = close_date
    @employee = employee
  end

  # Used to populate type cashes
  # only return cashes are open
  def types_cashes_opened
    types_cashes = []
    cash_policy = CashPolicy.new

    types_cashes << ["Servicios y Ventas", "services_sales"] if cash_policy.cash_services_sales.present? && @employee.sales_product?
    types_cashes << ["Impresiones", "impressions"] if cash_policy.cash_impressions.present? && @employee.sales_printing?

    return types_cashes
  end

  def cash
    cash_policy = CashPolicy.new

    if type_cash.present?
      if type_cash == "services_sales"
        return cash_policy.cash_services_sales
      else
        return cash_policy.cash_impressions
      end
    end

    if cash_policy.cash_services_sales.present?
      @type_cash = "services_sales"
      return cash_policy.cash_services_sales
    end

    if cash_policy.cash_impressions.present?
      @type_cash = "impressions"
      return cash_policy.cash_impressions
    end
  end

  # Obtaint total incomes by effective concept
  def total_effective
    return cash.total_effective
  end

  # Obtain total incomes by debit card
  def total_debit_card
    return cash.total_debit
  end

  # Obtain total incomes by credit card
  def total_credit_card
    return cash.total_credit
  end

  # Obtain the total of sales
  def total_sales
    total_effective + total_debit_card + total_credit_card
  end

  # Obtain the amount when the cash was open
  def open_amount
    cash.amount
  end

  # Obtain the total effective plus open amount quantity
  def total
    total_effective + open_amount
  end

  # Create the record for close cash
  # if type_cash == "servicios", close services_cash
  # if type_cash == "sales", close sales_cash
  def close_cash
    case type_cash
    when "services_sales"
      close_cash_services_sales
    when "impressions"
      close_cash_impressions
    end
  end

  private

  # create cash_closing_services_sale record
  # only there is a opening_cash active
  def close_cash_services_sales
    if is_closed?
      raise "Proceda a realizar la apertura de la caja."
    else
      ActiveRecord::Base.transaction do
        current_cash = cash
        cash_closing_services_sale = CashClosingServicesSale.new
        cash_closing_services_sale.close_date = close_date
        cash_closing_services_sale.user = employee
        cash_closing_services_sale.total_effective = total_effective
        cash_closing_services_sale.total_debit_card = total_debit_card
        cash_closing_services_sale.total_credit_card = total_credit_card
        cash_closing_services_sale.total_sales = total_sales
        cash_closing_services_sale.open_amount = open_amount
        cash_closing_services_sale.total = total
        cash_closing_services_sale.cash_opening_services_sale = current_cash
        raise "Error al realizar el cierre" unless cash_closing_services_sale.save

        current_cash.active = false
        raise "Error al realizar el cierre" unless current_cash.save

        return cash_closing_services_sale
      end

    end
  end

  # create cash_closing_impression record
  # only there is a opening_cash active
  def close_cash_impressions
    if is_closed?
      raise "Proceda a realizar la apertura de la caja."
    else
      ActiveRecord::Base.transaction do
        current_cash = cash
        cash_closing_impression = CashClosingImpression.new
        cash_closing_impression.type_cash = 'impressions'
        cash_closing_impression.close_date = close_date
        cash_closing_impression.user = employee
        cash_closing_impression.total_effective = total_effective
        cash_closing_impression.total_debit_card = total_debit_card
        cash_closing_impression.total_credit_card = total_credit_card
        cash_closing_impression.total_sales = total_sales
        cash_closing_impression.open_amount = open_amount
        cash_closing_impression.total = total
        cash_closing_impression.cash_opening_impression = current_cash
        raise "Error al realizar el cierre" unless cash_closing_impression.save

        current_cash.active = false
        raise "Error al realizar el cierre" unless current_cash.save

        return cash_closing_impression
      end
    end
  end

  # Check if there is a closed cash
  def is_closed?
    return cash_closed.blank?
  end

  # Obtain the current cash closed
  def cash_closed
    case type_cash
    when "services_sales"
      return CashPolicy.new.cash_services_sales
    when "impressions"
      return CashPolicy.new.cash_impressions
    end
  end

end
