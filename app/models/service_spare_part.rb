# == Schema Information
#
# Table name: service_spare_parts
#
#  id             :bigint           not null, primary key
#  name           :string
#  description    :text
#  price          :decimal(10, 2)
#  quantity       :integer
#  service_id     :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  spare_part_id  :bigint
#  control_number :integer          default(0)
#  payment_id     :bigint
#

# Managed the spare_parts used in services
class ServiceSparePart < ApplicationRecord
  belongs_to :service
  belongs_to :spare_part
  belongs_to :payment

end
