# == Schema Information
#
# Table name: services
#
#  id           :bigint           not null, primary key
#  client_id    :bigint
#  user_id      :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  image_client :string
#  paid         :boolean          default(FALSE)
#  number_folio :integer
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
