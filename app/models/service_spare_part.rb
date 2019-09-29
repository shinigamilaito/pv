# == Schema Information
#
# Table name: service_spare_parts
#
#  id             :bigint           not null, primary key
#  control_number :string           default("0")
#  description    :text
#  name           :string
#  price          :decimal(10, 2)
#  quantity       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_id     :bigint
#  service_id     :bigint
#  spare_part_id  :bigint
#

# Managed the spare_parts used in services
class ServiceSparePart < ApplicationRecord
  belongs_to :service
  belongs_to :spare_part
  belongs_to :payment

end
