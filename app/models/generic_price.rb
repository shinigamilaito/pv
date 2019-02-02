class GenericPrice < ApplicationRecord
  validates :name, :price, presence: true
  validates :name, uniqueness: true

  def name_price
    return "#{self.name} - #{self.price}"
  end
end
