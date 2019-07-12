# == Schema Information
#
# Table name: content_for_invitations
#
#  id             :bigint           not null, primary key
#  description    :text
#  image          :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint
#  subcategory_id :bigint
#

require 'test_helper'

class ContentForInvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
