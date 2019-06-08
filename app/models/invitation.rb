class Invitation < ApplicationRecord
  mount_uploader :imagen, InvitationUploader

  belongs_to :user
  has_many :invitation_printing_products, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: true}

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
