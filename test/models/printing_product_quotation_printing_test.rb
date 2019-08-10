# == Schema Information
#
# Table name: printing_product_quotation_printings
#
#  id                    :bigint           not null, primary key
#  quantity              :integer          default(0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  printing_product_id   :bigint
#  quotation_printing_id :bigint
#

require 'test_helper'

class PrintingProductQuotationPrintingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
