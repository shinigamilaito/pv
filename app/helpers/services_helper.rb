module ServicesHelper

  def totals(income)
    total_calculator = TotalCalculator.new(income.service, income)
    total_calculator.worforce = income.real_worforce
    total_calculator.discount = income.discount
    total_calculator.totals
  end

  def check_component?(equipment_customer, component)
    equipment_customer.components.include?(component)
  end

end
