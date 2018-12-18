class Equipment < ApplicationRecord
  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
