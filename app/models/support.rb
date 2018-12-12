class Support < ApplicationRecord
  belongs_to :equipment_customer
  belongs_to :payment_type
  belongs_to :client_type
end
