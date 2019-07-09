# == Schema Information
#
# Table name: payments
#
#  id                            :bigint           not null, primary key
#  change                        :decimal(10, 2)   default(0.0)
#  departure_date                :string
#  discount                      :decimal(10, 2)   default(0.0)
#  paid                          :boolean          default(FALSE)
#  paid_with                     :decimal(10, 2)   default(0.0)
#  ticket                        :integer          default(0)
#  worforce                      :decimal(10, 2)   default(0.0)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  cash_opening_services_sale_id :bigint
#  generic_price_id              :bigint
#  payment_type_id               :bigint
#  service_id                    :bigint
#  user_id                       :bigint
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
