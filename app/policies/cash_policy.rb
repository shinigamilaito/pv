class CashPolicy

  def initialize
  end

  def cash_services
    return CashOpeningService.find_by(active: true)
  end

  def cash_sales
    return CashOpeningSale.find_by(active: true)
  end

end
