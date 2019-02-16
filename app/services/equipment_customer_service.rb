class EquipmentCustomerService
  attr_reader :equipment_customer, :message_history

  def initialize(message_history, equipment_customer)
    @message_history = message_history
    @equipment_customer = equipment_customer
  end

  def create
    equipment_customer.message_histories << message_history unless message_history.message.blank?
    equipment_customer.save
  end

end
