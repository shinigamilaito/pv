class Service < ApplicationRecord
  belongs_to :client #Who is owner equipments
  belongs_to :user #Who created the service
  belongs_to :payment_type

  belongs_to :employee, class_name: 'User' #Who register the paid
  belongs_to :generic_price, optional: true

  has_many :equipment_customers
  has_many :service_spare_parts

  validates :client_id, presence: true
  validates :number_folio, presence: true, uniqueness: {case_sensitive: true}
  validates :paid_with, :change, presence: true, on: :update

  mount_base64_uploader :image_client, ImageSupportUploader

  before_save :set_number_folio

  def frequently_client_label
    total_services = Service.where(client_id: client_id).count

    if total_services >= 3
      return '[CLIENTE FRECUENTE]'
    else
      return ''
    end
  end

  def is_in_process?
    self.paid ? false : true
  end

  def self.search(term)
    Service.joins(:client)
      .where('services.paid = ?', true)
    	.where('CONCAT(LOWER(clients.name), LOWER(clients.first_name), LOWER(clients.last_name)) LIKE :term OR LOWER(services.number_folio) LIKE :term', term: "%#{term.downcase}%")
 	end

  def real_worforce
    if generic_price.present?
      generic_price.price
    else
      worforce
    end
  end

  def set_number_folio
    number_folio = Service.count + 1
  end

end
