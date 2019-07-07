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

require 'test_helper'

class ServiceSparePartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
