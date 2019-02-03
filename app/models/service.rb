class Service < ApplicationRecord
  belongs_to :client #Who is owner equipments
  belongs_to :user #Who created the service
  belongs_to :payment_type

  belongs_to :employee, class_name: 'User' #Who register the paid
  belongs_to :generic_price, optional: true

  has_many :equipment_customers
  has_many :service_spare_parts

  validates :client_id, presence: true
  validates :folio, presence: true, uniqueness: {case_sensitive: true}

  mount_base64_uploader :image_client, ImageSupportUploader

  def self.find_folios(client_id)
    services = where(client_id: client_id).order(created_at: :desc)

    folios_hash = {}
    folios_hash[:folios] = services.map(&:folio)
    folios_hash[:folios_present] = services.map do |service|
       service.folios_with_date_creation
    end

    return folios_hash
  end

  def obtain_discount(worforce, total_products, discount)
    total_worforce = BigDecimal.new(worforce)
    total_products = BigDecimal.new(total_products )
    total_discount = BigDecimal.new(discount)

    total_worforce_plus_total_products = total_worforce + total_products
    total_percentaje = total_worforce_plus_total_products * total_discount

    return (total_percentaje / BigDecimal.new('100.00'))
  end

  def generate_totals(worforce, discount)
    total_products = ServiceSparePart.costs_totals_in_this(self.service_spare_parts)
    total_worforce = worforce
    total_discount = self.obtain_discount(total_worforce, total_products, discount)
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
      return '[CLIENTE FRECUENTE]'
    else
      return ''
    end
  end

  def folios_with_date_creation
    paided = self.paid ? 'PAGADO' : 'EN PROCESO'
    return "#{self.folio} - Creado: #{self.created_at.strftime('%d/%m/%Y %I:%M %p')}. #{paided}"
  end

  def is_in_process?
    self.paid ? false : true
  end

  def self.search(term)
    Service.joins(:client)
      .where('services.paid = ?', true)
    	.where('CONCAT(LOWER(clients.name), LOWER(clients.first_name), LOWER(clients.last_name)) LIKE :term OR LOWER(services.folio) LIKE :term', term: "%#{term.downcase}%")
 	end
end
