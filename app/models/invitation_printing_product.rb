# == Schema Information
#
# Table name: invitation_printing_products
#
#  id                     :bigint           not null, primary key
#  user_id                :bigint
#  invitation_id          :bigint
#  printing_product_id    :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  from_printing_products :boolean          default(TRUE)
#

class InvitationPrintingProduct < ApplicationRecord
  belongs_to :user
  belongs_to :invitation, optional: true
  belongs_to :printing_product

  has_many :printing_product_quotations
end
