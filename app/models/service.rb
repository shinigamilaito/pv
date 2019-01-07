class Service < ApplicationRecord
  belongs_to :client
  belongs_to :user

  validates :client_id, presence: true
  validates :folio, presence: true, uniqueness: {case_sensitive: true}

  def self.find_folios(client_id)
    services = where(client_id: client_id).map(&:folio)
  end
end
