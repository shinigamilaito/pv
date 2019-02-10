class Product < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}

  def self.search(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.search_for_sales(term)
    where('LOWER(code) LIKE :term', term: "#{term.downcase}") if term.present?
  end

  def decrement_total
    self.quantity -= 1
    self.save
  end

  def is_available?(quantity)
    self.quantity >= quantity
  end
end
