class SparePart < ApplicationRecord
  validates :name, :price, :total, presence: true

  before_create :set_control_number

  def self.search(term)
    where('LOWER(name) LIKE :term or LOWER(description) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def set_control_number
    self.control_number = SparePart.count + 1
  end

end
