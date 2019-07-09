# == Schema Information
#
# Table name: invitations
#
#  id             :bigint           not null, primary key
#  description    :text
#  imagen         :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint
#  subcategory_id :bigint
#  user_id        :bigint
#

class Invitation < ApplicationRecord
  mount_uploader :imagen, InvitationUploader

  belongs_to :user
  belongs_to :category
  belongs_to :subcategory

  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :category_id, :subcategory_id, :user_id, presence: true

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
