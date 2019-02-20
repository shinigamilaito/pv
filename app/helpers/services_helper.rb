module ServicesHelper

  def totals(service)
    total_calculator = TotalCalculator.new(service)
    total_calculator.worforce = service.real_worforce
    total_calculator.discount = service.discount
    total_calculator.totals
  end

  def check_component?(equipment_customer, component)
    equipment_customer.components.include?(component)
  end

end
