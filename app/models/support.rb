class Support < ApplicationRecord
  belongs_to :equipment_customer
  belongs_to :payment_type
  belongs_to :client_type

  has_many :support_spare_parts

  validates :equipment_customer_id, :payment_type_id, :client_type_id, presence: true
  validates :description, :date_of_entry, presence: true
  validates :worforce, :discount, :departure_date, presence: true
end
