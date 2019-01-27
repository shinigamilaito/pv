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
end
