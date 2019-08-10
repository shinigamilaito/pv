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

class PrintingProductQuotationPrinting < ApplicationRecord
  belongs_to :printing_product
  belongs_to :quotation_printing
end
