class EquipmentCustomersController < ApplicationController

  def search
    @new_equipment_customer = EquipmentCustomer.new
    unless params[:search].blank?
      @equipment_customer = EquipmentCustomer.search(params[:search])

      if @equipment_customer.blank?
        flash[:error] = "Cliente / Folio no encontrado."
        redirect_to search_equipment_customers_path

      else
        flash[:success] = "Cliente / Folio encontrado correctamente."
        redirect_to @equipment_customer
      end
    end
  end

  def show
    session[:spare_part_ids] = nil
    session[:worforce] = nil
    session[:discount] = nil
    @new_equipment_customer = EquipmentCustomer.new
    @equipment_customer = EquipmentCustomer.find(params[:id])
  end

  def new
    @service = Service.find(params[:service_id])
    @new_equipment_customer = EquipmentCustomer.new
  end

  def create
    @new_equipment_customer = EquipmentCustomer.new(equipment_customer_params)
    @service = @new_equipment_customer.service
    if @new_equipment_customer.save
      render 'create'

    else
      #@from_create_action_equipment_customers = true      
      render 'new'
    end
  end

  private

  def equipment_customer_params
    params.require(:equipment_customer).permit(:service_id, :equipment_id, :brand_id, :description)
  end
end
