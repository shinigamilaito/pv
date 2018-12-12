class SaleSupportsController < ApplicationController
  def index
    @equipment_customer = EquipmentCustomer.new
    @from_equipment_customer = false
  end
end
