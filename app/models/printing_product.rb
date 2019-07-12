=begin
#
# Stores the information of the products
# that are used in impressions sales,
# invitations
#
=end

# == Schema Information
#
# Table name: printing_products
#
#  id             :bigint           not null, primary key
#  code           :string
#  content        :integer
#  imagen         :string
#  name           :string
#  product_type   :string
#  purchase_price :decimal(10, 2)   default(0.0)
#  purchase_unit  :string
#  sale_price     :decimal(10, 2)   default(0.0)
#  sale_unit      :string
#  stock          :integer
#  utility        :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PrintingProduct < ApplicationRecord
  mount_uploader :imagen, ImagenUploader

  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :content, :purchase_price, :purchase_unit, :sale_price, :sale_unit, :stock, presence: true

  # Search catalog index
  def self.search_index(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.product_types
    %w(Hoja Liston Perlas Celofan Flor Grabado Tul Accesorios)
  end

end
