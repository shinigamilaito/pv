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
#  bag            :decimal(10, 2)   default(0.0)
#  bag_stock      :integer          default(0)
#  box            :decimal(10, 2)   default(0.0)
#  box_stock      :integer          default(0)
#  code           :string
#  content        :integer
#  imagen         :string
#  increase_stock :integer          default(0)
#  meter          :decimal(10, 2)   default(0.0)
#  meter_stock    :integer          default(0)
#  name           :string
#  package        :decimal(10, 2)   default(0.0)
#  package_stock  :integer          default(0)
#  piece          :decimal(10, 2)   default(0.0)
#  product_type   :string
#  purchase_price :decimal(10, 2)   default(0.0)
#  purchase_unit  :string
#  roll           :decimal(10, 2)   default(0.0)
#  roll_stock     :integer          default(0)
#  set            :decimal(10, 2)   default(0.0)
#  set_stock      :integer          default(0)
#  stock          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PrintingProduct < ApplicationRecord
  mount_uploader :imagen, ImagenUploader

  has_many :printing_product_quotation_printings

  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :content, :purchase_price, :purchase_unit, :stock, presence: true

  # Search catalog index
  def self.search_index(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.product_types
    %w(Hoja Liston Perlas Celofan Flor Grabado Tul Accesorios Corte)
  end

  def sales_units_bigger_zero
    sales_units = {
        bag: 'Bolsa',
        box: 'Caja',
        meter: 'Metro',
        package: 'Paquete',
        piece: 'Pieza',
        roll: 'Rollo',
        set: 'Juego'
    }

    [:bag, :box, :meter, :package, :piece, :roll, :set].each do |attr|
      if send(attr) <= BigDecimal.new("0", 2)
        sales_units.delete(attr)
      end
    end

    sales_units
  end

end
