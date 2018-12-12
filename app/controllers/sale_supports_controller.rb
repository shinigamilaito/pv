class SaleSupportsController < ApplicationController
  def new
    @equipment_customer = EquipmentCustomer.new
    @from_equipment_customer = false
  end

  def search
  	params_search = {
  		client_id: params[:client_id],
  		folio_number: params[:folio_number] 		
  	}
  	@sale_support = SaleSupport.search(params_search)

  	if @sale_support.blank?
  		flash[:error] = "Cliente / Folio no encontrado."  
  		redirect_to new_sale_support_path
  	else
  	  flash[:success] = "Cliente / Folio encontrado correctamente."  
  	  redirect_to @sale_support
    end	
  end

  def show
  	
  end

end
