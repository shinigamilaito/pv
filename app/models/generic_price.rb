class GenericPrice < ApplicationRecord

  validates :name, :price, presence: true
  validates :name, uniqueness: true

  def self.search(term)
    where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def name_price
    return "#{self.name} - #{self.price}"
  end
end
