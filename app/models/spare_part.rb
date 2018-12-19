class SparePart < ApplicationRecord

  def self.search(term)
    	where('LOWER(name) LIKE :term or LOWER(description) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
