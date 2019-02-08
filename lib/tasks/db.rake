namespace :db do
  desc "Asignando user default to services"
  task default_employee: :environment do
    puts "Started..."
    user = User.first

    Service.where(employee_id: nil).each do |service|
      service.employee = user
      service.save(validate: false)
    end
    puts "End..."
  end

  desc "Asignado user default to message_histories"
  task default_user: :environment do
    puts "Started..."
    user = User.first

    MessageHistory.all.each do |message_history|
      message_history.user = user
      message_history.save
    end
    puts "End..."
  end

  desc "Asignado modelo a equipos de los clientes"
  task default_model_to_equipments: :environment do
    puts "Started..."
    model = EquipmentModel.first

    EquipmentCustomer.all.each do |equipment_customer|
      equipment_customer.equipment_model = model
      equipment_customer.save(validate: false)
    end
    puts "End..."
  end

  desc "Creando los componentes para las notas"
  task add_components_equipment_customer: :environment do
    puts "Started..."
    componentes = ["Cargador", "Maletin", "Teclado", "Bateria", "Funda", "Ratón"]

    componentes.each do |name_component|
      Component.create(name: name_component)
    end
    p "Components created"
    puts "End..."
  end

  desc "Creando los tipos de cables para las notas"
  task add_cable_types_equipment_customer: :environment do
    puts "Started..."
    CableType.destroy_all

    cable_types = ["Cable USB"]

    cable_types.each do |cable|
      CableType.create(name: cable)
    end
    p "Cable Types created"
    puts "End..."
  end
end
