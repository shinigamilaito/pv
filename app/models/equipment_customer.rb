class EquipmentCustomer < ApplicationRecord 
  belongs_to :equipment
  belongs_to :brand

  has_many :supports

  validates :equipment_id, :brand_id, presence: true 
  
  def self.search(params)
  	where(client_id: params[:client_id], folio: params[:folio_number]).first
  end
end
