class SupportsController < ApplicationController
  def new    
    @equipment_customer = EquipmentCustomer.find(params[:id])
    @new_support = Support.new
    @new_support.discount = BigDecimal.new("0.00")
    @new_support.worforce = BigDecimal.new("0.00")
  end

  def create
    spare_parts_used = SparePart.find(session[:spare_part_ids])
    support_spare_parts = SupportSparePart.create_spare_parts_used(spare_parts_used) 
    
    @support = Support.new(support_params)
    @support.support_spare_parts = support_spare_parts
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

  def add_spare_part
    session[:spare_part_ids] ||= []
    session[:worforce] ||= BigDecimal.new("0.00")
    session[:discount] ||= BigDecimal.new("0.00")    

    @spare_part = SparePart.find(params[:spare_part][:id])
    session[:spare_part_ids] << @spare_part.id unless session[:spare_part_ids].include?(@spare_part.id)
    @spare_parts = SparePart.find(session[:spare_part_ids])
    
    total_worforce = BigDecimal.new(session[:worforce])    
    total_discount = BigDecimal.new(session[:discount])
    
    @totals = Support.generate_totals(@spare_parts, total_worforce, total_discount)
  end

  private

  def support_params
    params.require(:support).permit(:equipment_customer_id, :payment_type_id, :client_type_id,
    :description, :date_of_entry, :worforce, :discount, :departure_date, :image_client)
  end
end
