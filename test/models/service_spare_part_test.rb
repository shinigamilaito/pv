# == Schema Information
#
# Table name: service_spare_parts
#
#  id             :bigint           not null, primary key
#  control_number :integer          default(0)
#  description    :text
#  name           :string
#  price          :decimal(10, 2)
#  quantity       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_id     :bigint
#  service_id     :bigint
#  spare_part_id  :bigint
#

require 'test_helper'

class ServiceSparePartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
