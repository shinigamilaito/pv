namespace :db do
  desc "Asignando user default to services"
  task default_employee: :environment do
    puts "Started..."
    user = User.first

    Service.where(employee_id: nil).each do |service|
      service.employee = user
      service.save
    end
    puts "End..."
  end
end
