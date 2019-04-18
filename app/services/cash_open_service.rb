class CashOpenService
  attr_accessor :type_cash, :open_date, :employee, :amount

  # Create a new cash object
  def initialize(open_date, employee, amount, type_cash = nil)
    @open_date = open_date
    @employee = employee
    @amount = BigDecimal.new(amount)
    @type_cash = type_cash
  end

  # Used to populate type cashes
  # only return cashes not open
  def types_cashes
    types_cashes = []
    cash_policy = CashPolicy.new

    types_cashes << ["Servicios", "services"] if cash_policy.cash_services.blank?
    types_cashes << ["Ventas", "sales"] if cash_policy.cash_sales.blank?

    return types_cashes
  end

  # Create the record for open cash
  # if type_cash == "servicios", open services_cash
  # if type_cash == "sales", open sales_cash
  def open_cash
    case type_cash
    when "services"
      open_cash_services
    when "sales"
      open_cash_sales
    end
  end

  private

  # create cash_opening_service record
  # only there is not a opening_cash active
  def open_cash_services
    if is_open?
      raise "Proceda a realizar el cierre de la caja."
    else
      cash_opening_service = CashOpeningService.new
      cash_opening_service.open_date = open_date
      cash_opening_service.user = employee
      cash_opening_service.amount = amount
      raise "Error al realizar la apertura" unless cash_opening_service.save

      return cash_opening_service
    end
  end

  # create cash_opening_sale record
  # only there is not a opening_cash active
  def open_cash_sales
    if is_open?
      raise "Proceda a realizar el cierre de la caja."
    else
      cash_opening_sale = CashOpeningSale.new
      cash_opening_sale.open_date = open_date
      cash_opening_sale.user = employee
      cash_opening_sale.amount = amount
      raise "Error al realizar la apertura" unless cash_opening_sale.save

      return cash_opening_sale
    end
  end

  # Check if there is a open cash
  def is_open?
    return cash_open.present?
  end

  # Obtain the current cash open
  def cash_open
    case type_cash
    when "services"
      return CashPolicy.new.cash_services
    when "sales"
      return CashPolicy.new.cash_sales
    end
  end

end
