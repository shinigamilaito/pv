class PrintingProduct < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :stock, presence: true
  validates :contains, :contain_unit, presence: true, if: :unit_big

  def unit_big
    !(%w(Pieza Metro Juego).include?(self.sale_unit))
  end
end
