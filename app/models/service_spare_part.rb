# Managed the spare_parts used in services
class ServiceSparePart < ApplicationRecord
  belongs_to :service
  belongs_to :spare_part
  belongs_to :payment

end
