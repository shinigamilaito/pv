# == Schema Information
#
# Table name: invitations
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  user_id              :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  imagen               :string
#  created_in_quotation :boolean          default(FALSE)
#

class Invitation < ApplicationRecord
  mount_uploader :imagen, InvitationUploader

  belongs_to :user
  has_many :invitation_printing_products, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: true}

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
