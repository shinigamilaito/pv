# == Schema Information
#
# Table name: message_histories
#
#  id                    :bigint           not null, primary key
#  message               :text
#  equipment_customer_id :bigint
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :bigint
#

class MessageHistory < ApplicationRecord
  belongs_to :equipment_customer
  belongs_to :user

  validates :message, presence: true
end
