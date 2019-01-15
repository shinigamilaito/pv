class Service < ApplicationRecord
  belongs_to :client
  belongs_to :user
  belongs_to :payment_type

  has_many :equipment_customers
  has_many :service_spare_parts

  validates :client_id, presence: true
  validates :folio, presence: true, uniqueness: {case_sensitive: true}

  mount_base64_uploader :image_client, ImageSupportUploader

  def self.find_folios(client_id)
    services = where(client_id: client_id)

    folios_hash = {}
    folios_hash[:folios] = services.map(&:folio)
    folios_hash[:folios_present] = services.map do |service|
      "#{service.folio} - Creado el: #{service.created_at.strftime("%d/%m/%Y - %I:%M %p")}"
    end

    return folios_hash
  end

  def self.obtain_discount(worforce, total_products, discount)
    total_worforce = BigDecimal.new(worforce)
    total_products = BigDecimal.new(total_products )
    total_discount = BigDecimal.new(discount)

    total_worforce_plus_total_products = total_worforce + total_products
    total_percentaje = total_worforce_plus_total_products * total_discount

    return (total_percentaje / BigDecimal.new("100.00"))
  end

  def self.generate_totals(spare_parts, worforce, discount)
    total_products = SparePart.costs_totals_in_this(spare_parts)
    total_worforce = worforce
    total_discount = Service.obtain_discount(total_worforce, total_products, discount)
    total_final = (total_products + total_worforce) - total_discount
    return {
      total_products: total_products,
      total_worforce: total_worforce,
      total_discount: total_discount,
      total_final: total_final
    }
  end

  def frequently_client_label
    total_services = Service.where(client_id: client_id).count

    if total_services >= 3
      return "[CLIENTE FRECUENTE]"
    else
      return ""
    end
  end
end
