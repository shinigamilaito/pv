class GenericPrice < ApplicationRecord

  validates :name, :price, presence: true
end
