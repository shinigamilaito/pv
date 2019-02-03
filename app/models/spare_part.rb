class SparePart < ApplicationRecord
  validates :name, :price, :total, presence: true

  def self.search(term)
    where('LOWER(name) LIKE :term or LOWER(description) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

end
