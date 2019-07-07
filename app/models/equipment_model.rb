# == Schema Information
#
# Table name: equipment_models
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EquipmentModel < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: true}

  def self.search_index(term)
    where('LOWER(name) LIKE :term OR LOWER(description) LIKE :term', term: "%#{term.downcase}%")
  end
end
