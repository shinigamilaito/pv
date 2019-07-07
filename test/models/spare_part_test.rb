# == Schema Information
#
# Table name: spare_parts
#
#  id            :bigint           not null, primary key
#  name          :string
#  description   :text
#  price         :decimal(10, 2)
#  total         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  code          :string
#  stock_minimum :integer          default(0)
#

require 'test_helper'

class SparePartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
