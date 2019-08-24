class CashOpenService
  attr_accessor :type_cash, :open_date, :employee, :amount

  # Create a new cash object
  def initialize(open_date, employee, amount, type_cash = nil)
    @open_date = open_date
    @employee = employee
    @amount = BigDecimal.new(amount, 2)
    @type_cash = type_cash
  end

  # Used to populate type cashes
  # only return cashes not open
  def types_cashes
    types_cashes = []
    cash_policy = CashPolicy.new
    cash_services_sales = cash_policy.cash_services_sales
    cash_impressions = cash_policy.cash_impressions

    types_cashes << ["Servicios y Ventas", "services_sales"] if cash_services_sales.blank? && @employee.sales_product?
    types_cashes << ["Impresiones", "impressions"] if cash_impressions.blank? && @employee.sales_printing?

    return types_cashes
  end

  # Create the record for open cash
  # if type_cash == "servicios_sales", open services_cash and sales_cash
  # if type_cash == "impressions", open impressions_cash
  def open_cash
    case type_cash
    when "services_sales"
      open_cash_services_sales
    when "impressions"
      open_cash_impressions
    end
  end

  private

  # Open cashes services_sales
  def open_cash_services_sales
    if is_open?
      raise "Proceda a realizar el cierre de la caja."
    else
      cash_opening_service_sale = CashOpeningServicesSale.new
      cash_opening_service_sale.open_date = open_date
      cash_opening_service_sale.user = employee
      cash_opening_service_sale.amount = amount
      raise "Error al realizar la apertura" unless cash_opening_service_sale.save

      return cash_opening_service_sale
    end
  end

  # open_cash_impressions
  def open_cash_impressions
    if is_open?
      raise "Proceda a realizar el cierre de la caja."
    else
      cash_opening_impression = CashOpeningImpression.new
      cash_opening_impression.type_cash = "impressions"
      cash_opening_impression.open_date = open_date
      cash_opening_impression.user = employee
      cash_opening_impression.amount = amount
      raise "Error al realizar la apertura" unless cash_opening_impression.save

      return cash_opening_impression
    end
  end

  # Check if there is a open cash
  def is_open?
    return cash_open.present?
  end

  # Obtain the current cash open
  def cash_open
    case type_cash
    when "services_sales"
      return CashPolicy.new.cash_services_sales
    when "impressions"
      return CashPolicy.new.cash_impressions
    end
  end

end
