class EquipmentCustomer < ApplicationRecord
  belongs_to :client
  belongs_to :equipment
  belongs_to :brand

  has_many :supports

  validates :client_id, :equipment_id, :brand_id, presence: true
  validates :description, presence: true
  validates :folio, presence: true, uniqueness: true

  def self.search(params)
  	where(client_id: params[:client_id], folio: params[:folio_number]).first
  end
end
