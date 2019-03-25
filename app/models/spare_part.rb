class SparePart < ApplicationRecord
  validates :name, :price, :total, presence: true
  validates :stock_minimum, presence: true

  def self.search(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

end
