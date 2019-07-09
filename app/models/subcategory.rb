# == Schema Information
#
# Table name: subcategories
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#

class Subcategory < ApplicationRecord
  belongs_to :category

  has_many :invitations

  validates :category_id, :name, presence: true
  validates :name, uniqueness: {case_sensitive: true}

  def self.search_index(term)
    where('LOWER(name) LIKE :term OR LOWER(description) LIKE :term', term: "%#{term.downcase}%")
  end
end
