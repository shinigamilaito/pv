=begin
#
# Almacena la información de los productos
# que son utilizados en las ventas de impresiones,
# invitaciones
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
  mount_uploader :imagen, PrintingProductUploader

  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :content, :purchase_price, :purchase_unit, :sale_price, :sale_unit, :stock, presence: true

  def unit_big
    !(%w(Pieza Metro Juego).include?(self.sale_unit))
  end

  # Busqueda transfer productos
=begin
  def self.search(term, product_id)
    product = PrintingProduct.find(product_id)
    stock_unit = product.contain_unit[0...-1]
    contains_unit = product.contain_unit

    where('LOWER(name) LIKE ? AND id != ? AND (sale_unit = ? OR contain_unit = ?)', "%#{term.downcase}%", product_id, stock_unit, contains_unit) if term.present?
  end
=end

  # Busqueda index catalogo
  def self.search_index(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  #def self.search_for_sales(term)
  #  where('LOWER(code) = ?', "#{term.downcase}") if term.present?
  #end
end
