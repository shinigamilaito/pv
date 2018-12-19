class Support < ApplicationRecord
  belongs_to :equipment_customer
  belongs_to :payment_type
  belongs_to :client_type

  has_many :support_spare_parts

  validates :equipment_customer_id, :payment_type_id, :client_type_id, presence: true
  validates :description, :date_of_entry, presence: true
  validates :worforce, :discount, :departure_date, presence: true

  def self.obtain_discount(worforce, total_products, discount)
  	total_worforce = BigDecimal.new(worforce)
  	total_products = BigDecimal.new(total_products)
  	total_discount = BigDecimal.new(discount)

  	total_worforce_plus_total_products = total_worforce + total_products
  	total_percentaje = total_worforce_plus_total_products * total_discount

  	return (total_percentaje / BigDecimal.new("100.00"))
  end

  def self.generate_totals(spare_parts, worforce, discount)
  	total_products = SparePart.costs_totals_in_this(spare_parts)
    total_worforce = worforce
    total_discount = Support.obtain_discount(total_worforce, total_products, discount)
    total_final = (total_products + total_worforce) - total_discount
    return {
      total_products: total_products,
      total_worforce: total_worforce,
      total_discount: total_discount,
      total_final: total_final
    }
  end
end
