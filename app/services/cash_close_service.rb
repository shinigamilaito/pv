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

    types_cashes << ["Servicios", "services"] if cash_policy.cash_services.present?
    types_cashes << ["Ventas", "sales"] if cash_policy.cash_sales.present?

    return types_cashes
  end

  def cash
    cash_policy = CashPolicy.new

    if type_cash.present?
      if type_cash == "services"
        return cash_policy.cash_services
      else
        return cash_policy.cash_sales
      end
    end

    if cash_policy.cash_services.present?
      @type_cash = "services"
      return cash_policy.cash_services
    end

    if cash_policy.cash_sales.present?
      @type_cash = "sales"
      return cash_policy.cash_sales
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
    when "services"
      close_cash_services
    when "sales"
      close_cash_sales
    end
  end

  private

  # create cash_closing_service record
  # only there is a opening_cash active
  def close_cash_services
    if is_closed?
      raise "Proceda a realizar la apertura de la caja."
    else
      cash_closing_service = CashClosingService.new
      cash_closing_service.close_date = close_date
      cash_closing_service.user = employee
      cash_closing_service.total_effective = total_effective
      cash_closing_service.total_debit_card = total_debit_card
      cash_closing_service.total_credit_card = total_credit_card
      cash_closing_service.total_sales = total_sales
      cash_closing_service.open_amount = open_amount
      cash_closing_service.total = total
      cash_closing_service.cash_opening_service = cash
      raise "Error al realizar el cierre" unless cash_closing_service.save

      return cash_opening_service
    end
  end

  # create cash_closing_sale record
  # only there is a opening_cash active
  def close_cash_sales
    if is_closed?
      raise "Proceda a realizar la apertura de la caja."
    else
      cash_closing_sale = CashClosingSale.new
      cash_closing_sale.close_date = close_date
      cash_closing_sale.user = employee
      cash_closing_sale.total_effective = total_effective
      cash_closing_sale.total_debit_card = total_debit_card
      cash_closing_sale.total_credit_card = total_credit_card
      cash_closing_sale.total_sales = total_sales
      cash_closing_sale.open_amount = open_amount
      cash_closing_sale.total = total
      cash_closing_sale.cash_opening_service = cash
      raise "Error al realizar el cierre" unless cash_closing_sale.save

      return cash_closing_sale
    end
  end

  # Check if there is a closed cash
  def is_closed?
    return cash_closed.blank?
  end

  # Obtain the current cash closed
  def cash_closed
    case type_cash
    when "services"
      return CashPolicy.new.cash_services
    when "sales"
      return CashPolicy.new.cash_sales
    end
  end

end
