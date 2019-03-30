class EquipmentCustomersController < ApplicationController
  def new
    @service = Service.find(params[:service_id])
    @new_equipment_customer = EquipmentCustomer.new
    @message_history = MessageHistory.new
    @components = Component.all
  end

  def create
    message_history = MessageHistory.new(message_history_params)
    message_history.user = current_user
    equipment_customer = EquipmentCustomer.new(equipment_customer_params)
    equipment_customer_service = EquipmentCustomerService.new(message_history, equipment_customer)

    if equipment_customer_service.create
      @service = equipment_customer.service
      @components = Component.all.order(created_at: :asc)
      @payments_policy = PaymentsPolicy.new(@service)
      @equipments_not_paid = @payments_policy.equipments_not_paid
      @payment = @payments_policy.current_payment
      render 'create'
    else
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
      @service = @equipment_customer.service
      render 'message_histories/add', status: :created
    else
      render 'fail_add_history_message', status: :bad_request
    end
  end

  def autocomplete_cable_types
    @cable_types = CableType.search(params[:term]).order(created_at: :desc)
  end

  private

  def equipment_customer_params
    params.require(:equipment_customer).permit(
      :service_id, :equipment_id, :brand_id, :equipment_model_id, :description,
      :cable_type_id, :serie_number, component_ids: []
    )
  end

  def message_history_params
    params.require(:message_history).permit(:message)
  end
end
