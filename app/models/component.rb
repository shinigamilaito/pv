# Cargador, Maletin, Teclado, etc

class Component < ApplicationRecord
  has_many :component_equipment_customers, :dependent => :destroy
  has_many :equipment_customers, :through => :component_equipment_customers
end
