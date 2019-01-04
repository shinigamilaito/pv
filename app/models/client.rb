class Client < ApplicationRecord
	validates :name, uniqueness: {case_sensitive: true, scope: :first_name }
	validates :first_name, presence: true
	validates :mobile_phone, presence: true
	validates :home_phone, presence: true

	def self.search(term)
    	where('LOWER(name) LIKE :term or LOWER(first_name) LIKE :term or LOWER(last_name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  	end
end
