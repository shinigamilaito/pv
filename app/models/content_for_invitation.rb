=begin

Catalog of contents to save the texts of the invitations.
Same use as the invitations catalog (sample), only the images will be text.

=end

# == Schema Information
#
# Table name: content_for_invitations
#
#  id             :bigint           not null, primary key
#  description    :text
#  image          :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint
#  subcategory_id :bigint
#

class ContentForInvitation < ApplicationRecord
  mount_uploader :image, ImagenUploader

  belongs_to :category
  belongs_to :subcategory

  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :category_id, :subcategory_id, presence: true

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
