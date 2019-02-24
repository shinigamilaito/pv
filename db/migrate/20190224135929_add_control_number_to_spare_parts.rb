class AddControlNumberToSpareParts < ActiveRecord::Migration[5.1]
  def change
    add_column :spare_parts, :control_number, :integer, default: "0"
    add_column :service_spare_parts, :control_number, :integer, default: "0"

    SparePart.all.order(:created_at).each_with_index do |spare_part, index|
      spare_part.control_number = index + 1
      spare_part.save
      ServiceSparePart.where(name: spare_part.name).each do |service_spare_part|
        service_spare_part.control_number = index + 1
        service_spare_part.save
      end
    end

  end
end
