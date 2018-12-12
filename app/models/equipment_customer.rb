class EquipmentCustomer < ApplicationRecord
  belongs_to :client
  belongs_to :equipment
  belongs_to :brand

  validates :client_id, :equipment_id, :brand_id, presence: true
  validates :description, presence: true
  validates :folio, presence: true, uniqueness: true
end
