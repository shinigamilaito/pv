class ChangeColumnFolioServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :number_folio, :integer

    Service.select(:id).order(:created_at).each_with_index do |service, index|
      service.number_folio = index + 1
      service.save
    end

    remove_column :services, :folio, :string
  end
end
