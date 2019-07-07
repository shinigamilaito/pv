# == Schema Information
#
# Table name: spare_parts
#
#  id            :bigint           not null, primary key
#  name          :string
#  description   :text
#  price         :decimal(10, 2)
#  total         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  code          :string
#  stock_minimum :integer          default(0)
#

class SparePart < ApplicationRecord
  validates :name, :price, :total, presence: true
  validates :stock_minimum, presence: true

  def self.search(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

end
