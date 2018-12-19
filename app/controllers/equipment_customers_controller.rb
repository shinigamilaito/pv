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
    @new_equipment_customer = EquipmentCustomer.new
    @new_support = Support.new  
    @equipment_customer = EquipmentCustomer.find(params[:id])    
  end

  def new
    @equipment_customer = EquipmentCustomer.new
  end

  def create
    @new_equipment_customer = EquipmentCustomer.new(equipment_customer_params)
    if @new_equipment_customer.save
      flash[:success] = "Equipo registrado."
      redirect_to @new_equipment_customer
    else
      @from_create_action = true
      flash.now[:error] = "Proporcione los datos correctamente."
      render "search"
    end
  end

  private

  def equipment_customer_params
    params.require(:equipment_customer).permit(:client_id, :folio, :equipment_id, :brand_id, :description)
  end
end
