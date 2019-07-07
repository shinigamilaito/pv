# == Schema Information
#
# Table name: quotation_printings
#
#  id                         :bigint           not null, primary key
#  invitation_id              :bigint
#  client_id                  :bigint
#  cost_piece                 :decimal(10, 2)   default(0.0)
#  total_pieces               :integer
#  cost_elaboration           :decimal(10, 2)   default(0.0)
#  total_quotations           :decimal(10, 2)   default(0.0)
#  total_cost                 :decimal(10, 2)   default(0.0)
#  utility                    :decimal(10, 2)   default(0.0)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  number_folio               :string
#  status                     :string
#  paid_with                  :decimal(10, 2)   default(0.0)
#  payment                    :decimal(10, 2)   default(0.0)
#  change                     :decimal(10, 2)   default(0.0)
#  difference                 :decimal(10, 2)   default(0.0)
#  payment_type_id            :bigint
#  full_payment               :boolean
#  user_id                    :bigint
#  cash_opening_impression_id :bigint
#  ticket                     :integer          default(0)
#  imagen                     :string
#

class QuotationPrinting < ApplicationRecord
  mount_uploader :imagen, InvitationUploader

  belongs_to :invitation
  belongs_to :client
  belongs_to :user
  belongs_to :payment_type, optional: true
  belongs_to :cash_opening_impression

  has_many :printing_product_quotations

  validates :client_id, :user_id, presence: true
  validates :number_folio, presence: true, uniqueness: {case_sensitive: true}

  before_create :set_number_folio

  def set_number_folio
    self.number_folio = QuotationPrinting.count + 1
  end

  def set_number_ticket
    return QuotationPrinting.count + 1 # + PartialPaymentQuotationPrinting.count
  end

  def self.total(quotation_printings)
    return nil if quotation_printings.blank?

    quotation_printings
      .map {|quotation_printing| quotation_printing.payment }
      .sum
  end
end
