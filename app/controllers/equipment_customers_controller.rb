class EquipmentCustomersController < ApplicationController

  def search
    @new_equipment_customer = EquipmentCustomer.new
    unless params[:search].blank?
      @equipment_customer = EquipmentCustomer.search(params[:search])

      if @equipment_customer.blank?
        flash[:error] = 'Cliente / Folio no encontrado.'
        redirect_to search_equipment_customers_path

      else
        flash[:success] = 'Cliente / Folio encontrado correctamente.'
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
    @message_history = MessageHistory.new
  end

  def create
    message_history = MessageHistory.new(message_history_params)
    message_history.user = current_user
    @new_equipment_customer = EquipmentCustomer.new(equipment_customer_params)
    @new_equipment_customer.message_histories << message_history unless message_history.message.blank?
    @service = @new_equipment_customer.service

    if @new_equipment_customer.save
      render 'create'
    else
      #@from_create_action_equipment_customers = true
      render 'new'
    end
  end

  def add_history_message
    @equipment_customer = EquipmentCustomer.find(params[:equipment_customer_id])
    @equipment_customer.message_histories << MessageHistory.new({
      message: params[:message],
      user: current_user
    })

    if @equipment_customer.save
      render 'add_history_message', status: :created
    else
      render 'fail_add_history_message', status: :bad_request
    end
  end

  private

  def equipment_customer_params
    params.require(:equipment_customer).permit(:service_id, :equipment_id, :brand_id, :equipment_model_id, :description)
  end

  def message_history_params
    params.require(:message_history).permit(:message)
  end
end
