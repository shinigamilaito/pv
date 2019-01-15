# Managed the spare_parts used in services

class ServiceSparePart < ApplicationRecord
  belongs_to :service
  
  def self.create_spare_parts_used(spare_parts)
    service_spare_parts = []
    spare_parts.each do |spare_part|
      service_spare_part = ServiceSparePart.new
      service_spare_part.name = spare_part.name
      service_spare_part.description = spare_part.description
      service_spare_part.price = spare_part.price
      service_spare_part.quantity = 1
      service_spare_parts << service_spare_part
    end

    return service_spare_parts
  end
end
