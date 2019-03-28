class Product < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :stock_minimum, presence: true

  def self.search(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.search_for_sales(term)
    Product.find_by_code(term)
    #where('LOWER(code) LIKE :term', term: "#{term.downcase}") if term.present?
  end

end
