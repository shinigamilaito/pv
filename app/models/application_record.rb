class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
