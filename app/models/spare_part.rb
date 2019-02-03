class SparePart < ApplicationRecord
  validates :name, :price, :total, presence: true

  def self.search(term)
    where('LOWER(name) LIKE :term or LOWER(description) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def decrement_total
    self.total = self.total - 1
    self.save
  end

  def is_available?(quantity)
    self.total >= quantity
  end

end
