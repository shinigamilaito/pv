namespace :db do
  desc "Asignando user default to services"
  task default_employee: :environment do
    "Started..."
    user = User.first

    Service.where(employee_id: nil).each do |service|
      service.employee = user
      service.save
    end
    "End..."
  end
end
