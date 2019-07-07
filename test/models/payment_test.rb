# == Schema Information
#
# Table name: payments
#
#  id                            :bigint           not null, primary key
#  payment_type_id               :bigint
#  worforce                      :decimal(10, 2)   default(0.0)
#  discount                      :decimal(10, 2)   default(0.0)
#  departure_date                :string
#  user_id                       :bigint
#  generic_price_id              :bigint
#  paid_with                     :decimal(10, 2)   default(0.0)
#  change                        :decimal(10, 2)   default(0.0)
#  ticket                        :integer          default(0)
#  service_id                    :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  paid                          :boolean          default(FALSE)
#  cash_opening_services_sale_id :bigint
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
