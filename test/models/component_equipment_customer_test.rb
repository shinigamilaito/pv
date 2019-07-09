# == Schema Information
#
# Table name: component_equipment_customers
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  component_id          :bigint
#  equipment_customer_id :bigint
#

require 'test_helper'

class ComponentEquipmentCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
