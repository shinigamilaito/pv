# == Schema Information
#
# Table name: equipment_customers
#
#  id                    :bigint           not null, primary key
#  equipment_id          :bigint
#  brand_id              :bigint
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  service_id            :bigint
#  equipment_model_id    :bigint
#  cable_type_id         :bigint
#  payment_id            :bigint
#  serie_number          :string
#  component_description :text
#

require 'test_helper'

class EquipmentCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
