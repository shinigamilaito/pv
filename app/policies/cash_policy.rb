class CashPolicy

  def initialize
  end

  def cash_services_sales
    return CashOpeningServicesSale.find_by(active: true)
  end

  def cash_impressions
    return nil
  end

end
