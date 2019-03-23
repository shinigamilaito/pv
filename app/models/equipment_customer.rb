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

  validates :equipment_id, :brand_id, :equipment_model_id, :service_id, presence: true

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
end
