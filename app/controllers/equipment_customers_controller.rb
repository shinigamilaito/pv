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
    equipment_model_name = params[:equipment_customer][:equipment_model_id]
    brand_name = params[:equipment_customer][:brand_id]
    equipment_customer = associate_equipment_model(equipment_customer, equipment_model_name)
    equipment_customer = associate_brand(equipment_customer, brand_name)
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
    @equipment_customer.updated_at = Time.now
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
      :component_description, :serie_number, component_ids: []
    )
  end

  def message_history_params
    params.require(:message_history).permit(:message)
  end

  def associate_equipment_model(equipment_customer, equipment_model_name)
    if equipment_model_name.to_i == 0 #Crear el equipment_model
      equipment_customer.equipment_model = EquipmentModel.new(
        name: equipment_model_name,
        description: equipment_model_name
      )
    end

    return equipment_customer
  end

  def associate_brand(equipment_customer, brand_name)
    if brand_name.to_i == 0 #Crear el equipment_model
      equipment_customer.brand = Brand.new(
        name: brand_name,
        specifications: brand_name
      )
    end

    return equipment_customer
  end
end
