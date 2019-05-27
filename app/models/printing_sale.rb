class PrintingSale < ApplicationRecord
  belongs_to :user
  belongs_to :payment_type
  belongs_to :client
end
