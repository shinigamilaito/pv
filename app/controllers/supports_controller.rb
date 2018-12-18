class SupportsController < ApplicationController
  def new    
    @equipment_customer = EquipmentCustomer.find(params[:id])
    @new_support = Support.new
  end

  def create
    @support = Support.new(support_params)
    if @support.save
      flash[:success] = "Soporte creado correctamente."
      redirect_to  @support.equipment_customer
    else
      flash.now[:error] = "Proporcione los datos correctos."
      @new_equipment_customer = EquipmentCustomer.new
      @new_support = @support
      @equipment_customer = @support.equipment_customer
      render "equipment_customers/show"
    end
  end

  private

  def support_params
    params.require(:support).permit(:equipment_customer_id, :payment_type_id, :client_type_id,
    :description, :date_of_entry, :worforce, :discount, :departure_date)
  end
end
