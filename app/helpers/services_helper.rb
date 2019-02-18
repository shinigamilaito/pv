module ServicesHelper

  def totals(service)
    total_calculator = TotalCalculator.new(service)
    total_calculator.worforce = worforce(service)
    total_calculator.discount = service.discount
    total_calculator.totals
  end

  def worforce(service)
    if service.generic_price.present?
      service.generic_price.price
    else
      service.worforce
    end
  end

  def check_component?(equipment_customer, component)
    equipment_customer.components.include?(component)
  end

end
