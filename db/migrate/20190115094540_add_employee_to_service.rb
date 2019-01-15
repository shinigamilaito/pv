class AddEmployeeToService < ActiveRecord::Migration[5.1]
  def change
    add_reference :services, :employee, index: true
    add_foreign_key :services, :users, column: :employee_id
  end
end
