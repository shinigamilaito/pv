# == Schema Information
#
# Table name: equipment_customers
#
#  id                    :bigint           not null, primary key
#  component_description :text
#  description           :text
#  serie_number          :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  brand_id              :bigint
#  cable_type_id         :bigint
#  equipment_id          :bigint
#  equipment_model_id    :bigint
#  payment_id            :bigint
#  service_id            :bigint
#

require 'test_helper'

class EquipmentCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
