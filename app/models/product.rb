# == Schema Information
#
# Table name: products
#
#  id            :bigint           not null, primary key
#  code          :string
#  name          :string
#  quantity      :integer
#  price         :decimal(10, 2)   default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text
#  stock_minimum :integer          default(0)
#

class Product < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :stock_minimum, presence: true

  def self.search(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.search_for_sales(term)
    where('LOWER(code) = ?', "#{term.downcase}") if term.present?
  end

end
