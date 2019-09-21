# == Schema Information
#
# Table name: spare_parts
#
#  id             :bigint           not null, primary key
#  code           :string
#  description    :text
#  name           :string
#  price          :decimal(10, 2)
#  price_purchase :decimal(10, 2)
#  stock_minimum  :integer          default(0)
#  total          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class SparePartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
