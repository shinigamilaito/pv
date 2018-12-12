class SaleSupport < ApplicationRecord
  belongs_to :equipment_customer


  def self.search(params) 
  	SaleSupport.joins(:equipment_customer)
  		.where('equipment_customers.client_id' => params[:client_id].to_i, 'equipment_customers.folio' => params[:folio_number])
 		.first
  end
end
