class EquipmentCustomer < ApplicationRecord
  belongs_to :equipment
  belongs_to :brand
  belongs_to :equipment_model
  belongs_to :service

  has_many :supports
  has_many :message_histories

  validates :equipment_id, :brand_id, :equipment_model_id, :service_id, presence: true

  def self.search(params)
  	where(client_id: params[:client_id], folio: params[:folio_number]).first
  end

  def title_header
    "<b>Equipo:</b> #{self.equipment.name} <b>Marca:</b> #{self.brand.name} <br/>
    <span style= 'font-size: 12px;'>Ingreso el: #{self.created_at.strftime("%d/%m/%Y %I:%M %p")}</span>"
  end

end
