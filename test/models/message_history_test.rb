# == Schema Information
#
# Table name: message_histories
#
#  id                    :bigint           not null, primary key
#  message               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  equipment_customer_id :bigint
#  user_id               :bigint
#

require 'test_helper'

class MessageHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
