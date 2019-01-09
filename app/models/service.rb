class Service < ApplicationRecord
  belongs_to :client
  belongs_to :user

  has_many :equipment_customers

  validates :client_id, presence: true
  validates :folio, presence: true, uniqueness: {case_sensitive: true}

  def self.find_folios(client_id)
    services = where(client_id: client_id)

    folios_hash = {}
    folios_hash[:folios] = services.map(&:folio)
    folios_hash[:folios_present] = services.map do |service|
      "#{service.folio} - Creado el: #{service.created_at.strftime("%d/%m/%Y - %I:%M %p")}"
    end

    return folios_hash
  end
end
