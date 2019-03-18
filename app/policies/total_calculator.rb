class TotalCalculator
  attr_accessor :worforce, :discount, :service, :payment

  def initialize(service, payment = nil)
    @service = service
    @payment = payment
  end

  def totals
    total_products = cost_spare_parts
    total_discount = obtain_discount
    total_final = (total_products + worforce) - total_discount

    return {
      total_products: total_products,
      total_worforce: worforce,
      total_discount: total_discount,
      total_final: total_final,
      paid_with: payment.paid_with,
      change: payment.change
    }
  end

  private

  def current_payment
    @payment
  end

  def payment
    if current_payment.nil?
      payments_policy = PaymentsPolicy.new(service)
      return payments_policy.current_payment
    else
      return current_payment
    end
  end

  def cost_spare_parts
    total = payment.service_spare_parts.inject(BigDecimal("0.00")) do |total, spare_part|
      total += total_cost(spare_part)
      total
    end

    total
  end

  def obtain_discount
    total_worforce = BigDecimal.new(worforce)
    total_products = cost_spare_parts
    total_discount = BigDecimal.new(discount)

    total_worforce_plus_total_products = total_worforce + total_products
    total_percentaje = total_worforce_plus_total_products * total_discount

    return (total_percentaje / BigDecimal.new('100.00'))
  end

  def service_spare_parts
    service.service_spare_parts
  end

  def total_cost(spare_part)
    BigDecimal(spare_part.price * spare_part.quantity)
  end

end
