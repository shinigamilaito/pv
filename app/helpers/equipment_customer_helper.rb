module EquipmentCustomerHelper

  def select_component(equipment_customer, component)
    if equipment_customer.new_record?
      return false
    else
      return equipment_customer.components.include?(component)
    end
  end

  def title_header(equipment_customer)
    "<b>Equipo:</b> #{equipment_customer.equipment.name} <b>Marca:</b> #{equipment_customer.brand.name} <br/>
    <span style= 'font-size: 12px;'>Ingreso el: #{date_time_helper(equipment_customer.created_at)}</span>"
  end
end
