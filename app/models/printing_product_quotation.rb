# == Schema Information
#
# Table name: printing_product_quotations
#
#  id                             :bigint           not null, primary key
#  invitation_printing_product_id :bigint
#  quotation_printing_id          :bigint
#  user_id                        :bigint
#  code                           :string
#  name                           :string
#  quantity                       :decimal(10, 2)   default(0.0)
#  purchase_price                 :decimal(10, 2)   default(0.0)
#  real_price                     :decimal(20, 10)  default(0.0)
#  total                          :decimal(10, 2)   default(0.0)
#  sale_unit                      :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class PrintingProductQuotation < ApplicationRecord
  belongs_to :invitation_printing_product, optional: true #No usado
  belongs_to :quotation_printing, optional: true
  belongs_to :user
end
