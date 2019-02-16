class Client < ApplicationRecord
	validates :name, uniqueness: {case_sensitive: true, scope: :first_name }
	validates :first_name, presence: true

	def self.search(term)
    where('LOWER(name) LIKE :term or LOWER(first_name) LIKE :term or LOWER(last_name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

	def formal_name
		name + first_name + last_name
	end
end
