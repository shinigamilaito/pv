# == Schema Information
#
# Table name: generic_prices
#
#  id         :bigint           not null, primary key
#  name       :string
#  price      :decimal(10, 2)   default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class GenericPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
