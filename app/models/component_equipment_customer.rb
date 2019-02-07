class ComponentEquipmentCustomer < ApplicationRecord
  belongs_to :component
  belongs_to :equipment_customer
end
