class EquipmentCustomersController < ApplicationController

  def new
    @equipment_customer = EquipmentCustomer.new
  end

  def create
    @equipment_customer = EquipmentCustomer.new(equipment_customer_params)
    if @equipment_customer.save
      flash[:success] = "Equipo registrado."
      redirect_to sale_supports_path      
    else
      render "new"
    end
  end

  private

  def equipment_customer_params
    params.require(:equipment_customer).permit(:client_id, :folio, :equipment_id, :brand_id, :description)
  end
end
