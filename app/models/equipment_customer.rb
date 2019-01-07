class EquipmentCustomer < ApplicationRecord 
  belongs_to :equipment
  belongs_to :brand
  belongs_to :service

  has_many :supports

  validates :equipment_id, :brand_id, :service_id, presence: true 
  
  def self.search(params)
  	where(client_id: params[:client_id], folio: params[:folio_number]).first
  end

  def title_header
  	"<b>Fecha de Registro:</b> #{self.created_at.strftime("%d/%m/%Y - %I:%M %p")} <b>Equipo:</b> #{self.equipment.name} <b>Marca:</b> #{self.brand.name}"
  end
end
