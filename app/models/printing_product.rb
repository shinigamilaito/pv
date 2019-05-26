class PrintingProduct < ApplicationRecord
  mount_uploader :imagen, PrintingProductUploader

  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :stock, presence: true
  validates :contains, :contain_unit, presence: true, if: :unit_big

  def unit_big
    !(%w(Pieza Metro Juego).include?(self.sale_unit))
  end

  # Busqueda transfer productos
  def self.search(term, product_id)
    product = PrintingProduct.find(product_id)
    stock_unit = product.contain_unit[0...-1]
    contains_unit = product.contain_unit

    where('LOWER(name) LIKE ? AND id != ? AND (sale_unit = ? OR contain_unit = ?)', "%#{term.downcase}%", product_id, stock_unit, contains_unit) if term.present?
  end

  # Busqueda index catalogo
  def self.search_index(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end
end
