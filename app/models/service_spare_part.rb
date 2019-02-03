# Managed the spare_parts used in services
class ServiceSparePart < ApplicationRecord
  belongs_to :service

  def self.new_from(spare_part)
    service_spare_part = ServiceSparePart.new
    service_spare_part.name = spare_part.name
    service_spare_part.description = spare_part.description
    service_spare_part.price = spare_part.price
    service_spare_part.quantity = 1

    service_spare_part
  end

  def total_cost
    self.price * self.quantity
  end

  def self.costs_totals_in_this(service_spare_parts)
  	total_cost = BigDecimal("0.00")

  	service_spare_parts.each do |service_spare_part|
  		total_cost += BigDecimal(service_spare_part.total_cost)
  	end

  	return total_cost
  end

end
