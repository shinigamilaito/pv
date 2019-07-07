# == Schema Information
#
# Table name: component_equipment_customers
#
#  id                    :bigint           not null, primary key
#  component_id          :bigint
#  equipment_customer_id :bigint
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class ComponentEquipmentCustomer < ApplicationRecord
  belongs_to :component
  belongs_to :equipment_customer
end
