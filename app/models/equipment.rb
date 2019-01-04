class Equipment < ApplicationRecord
	validates :name, presence: true, uniqueness: {case_sensitive: true}

  	def self.search(term)
    	where('LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  	end
end
