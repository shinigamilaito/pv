class Payment < ApplicationRecord
  belongs_to :payment_type, optional: true
  belongs_to :user, optional: true
  belongs_to :generic_price, optional: true
  belongs_to :service

  has_many :service_spare_parts
  has_many :equipment_customers

  def real_worforce
    if generic_price.present?
      generic_price.price
    else
      worforce
    end
  end
  
end
