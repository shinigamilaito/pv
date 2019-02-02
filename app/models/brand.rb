class Brand < ApplicationRecord
		validates :name, presence: true, uniqueness: {case_sensitive: true}
  	
		def self.search_index(term)
			where('LOWER(name) LIKE :term OR LOWER(specifications) LIKE :term', term: "%#{term.downcase}%")
		end
end
