class MessageHistory < ApplicationRecord
  belongs_to :equipment_customer
  belongs_to :user

  validates :message, presence: true
end
