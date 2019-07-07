# == Schema Information
#
# Table name: cable_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CableType < ApplicationRecord
  has_many :equipment_customers
end
