# == Schema Information
#
# Table name: components
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Cargador, Maletin, Teclado, etc
class Component < ApplicationRecord
  has_many :component_equipment_customers, :dependent => :destroy
  has_many :equipment_customers, :through => :component_equipment_customers
end
