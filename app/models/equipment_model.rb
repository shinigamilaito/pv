class EquipmentModel < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: true}

  def self.search(term)
    	where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.search_index(term)
    where('LOWER(name) LIKE :term OR LOWER(description) LIKE :term', term: "%#{term.downcase}%")
  end
end
