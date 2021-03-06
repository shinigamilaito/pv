# == Schema Information
#
# Table name: equipment_customers
#
#  id                    :bigint           not null, primary key
#  equipment_id          :bigint
#  brand_id              :bigint
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  service_id            :bigint
#  equipment_model_id    :bigint
#  cable_type_id         :bigint
#  payment_id            :bigint
#  serie_number          :string
#  component_description :text
#

class EquipmentCustomer < ApplicationRecord
  belongs_to :equipment
  belongs_to :brand
  belongs_to :equipment_model
  belongs_to :service
  belongs_to :cable_type, optional: true
  belongs_to :payment, optional: true

  has_many :message_histories

  has_many :component_equipment_customers, :dependent => :destroy
  has_many :components, :through => :component_equipment_customers
  accepts_nested_attributes_for :component_equipment_customers, allow_destroy: true

  validates :equipment_id, :service_id, presence: true
  validates :serie_number, presence: true

  after_create :update_service
  after_update :update_service

  def self.search(params)
  	where(client_id: params[:client_id], folio: params[:folio_number]).first
  end

  def is_in_process?
    if self.payment.nil?
      return true
    else
      return self.payment.paid ? false : true
    end
  end

  def update_service
    service = self.service
    service.updated_at = self.updated_at
    service.save
  end
end
