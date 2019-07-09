# == Schema Information
#
# Table name: services
#
#  id           :bigint           not null, primary key
#  image_client :string
#  number_folio :integer
#  paid         :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  client_id    :bigint
#  user_id      :bigint
#

class Service < ApplicationRecord
  belongs_to :client #Who is owner equipments
  belongs_to :user #Who created the service

  has_many :equipment_customers
  has_many :service_spare_parts
  has_many :payments

  validates :client_id, presence: true
  validates :number_folio, presence: true, uniqueness: {case_sensitive: true}

  mount_base64_uploader :image_client, ImageSupportUploader

  before_create :set_number_folio

  def frequently_client_label
    total_services = Service.where(client_id: client_id).count

    if total_services >= 3
      return '[CLIENTE FRECUENTE]'
    else
      return ''
    end
  end

  def is_in_process?
    return false if self.new_record?

    if equipment_customers.blank?
      return true
    else
      return equipment_customers.where('payment_id IS NULL', false).blank? ? false : true
    end
  end

  def set_number_folio
    self.number_folio = Service.count + 1
  end

  def finished_payments
    payments.where('paid = ?', true)
  end

end
