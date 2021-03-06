# == Schema Information
#
# Table name: products
#
#  id             :bigint           not null, primary key
#  code           :string
#  description    :text
#  imagen         :string
#  name           :string
#  price          :decimal(10, 2)   default(0.0)
#  price_purchase :decimal(10, 2)
#  quantity       :integer
#  stock_minimum  :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  brand_id       :bigint
#

class Product < ApplicationRecord
  mount_uploader :imagen, ImagenUploader

  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :stock_minimum, presence: true

  belongs_to :brand, optional: true

  def self.search(term)
    Product
    .left_outer_joins(:brand)
    .where('LOWER(brands.name) LIKE :term or (LOWER(products.code) LIKE :term or LOWER(products.name) LIKE :term)', term: "%#{term.downcase}%") if term.present?
  end

  def self.search_for_sales(term)
    where('LOWER(code) = ?', "#{term.downcase}") if term.present?
  end

end
