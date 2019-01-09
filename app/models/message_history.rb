class MessageHistory < ApplicationRecord
  belongs_to :equipment_customer

  validates :message, presence: true
  
end
