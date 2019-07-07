# == Schema Information
#
# Table name: quotations
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  total      :decimal(20, 14)  default(0.0)
#  folio      :integer          default(0)
#  client_id  :bigint
#  status     :string           default("Vigente")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Quotation < ApplicationRecord
  belongs_to :user
  belongs_to :client

  has_many :quotation_products, dependent: :destroy
end
