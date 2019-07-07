# == Schema Information
#
# Table name: equipments
#
#  id             :bigint           not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  specifications :text
#

# Laptop, Impresora, etc
class Equipment < ApplicationRecord
	validates :name, presence: true, uniqueness: {case_sensitive: true}

	def self.search_index(term)
		where('LOWER(name) LIKE :term OR LOWER(specifications) LIKE :term', term: "%#{term.downcase}%")
	end
end
