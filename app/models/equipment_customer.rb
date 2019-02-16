class EquipmentCustomer < ApplicationRecord
  belongs_to :equipment
  belongs_to :brand
  belongs_to :equipment_model
  belongs_to :service
  belongs_to :cable_type

  has_many :message_histories

  has_many :component_equipment_customers, :dependent => :destroy
  has_many :components, :through => :component_equipment_customers
  accepts_nested_attributes_for :component_equipment_customers, allow_destroy: true

  validates :equipment_id, :brand_id, :equipment_model_id, :service_id, presence: true

  def self.search(params)
  	where(client_id: params[:client_id], folio: params[:folio_number]).first
  end

  #def self.load_associations(service_id)
  #  EquipmentCustomer
  #    .joins(:service, :equipment, :brand, :equipment_model, :cable_type)
  #    .select('equipment_customers.*, services.id as service_id, equipments.name as equipment_name, brands.name as brand_name, equipment_models.name as equipment_model_name, cable_types.name as cable_type_name')
  #    .where('services.id = ?', service_id)
  #    .order('equipment_customers.created_at desc')
  #end

end
