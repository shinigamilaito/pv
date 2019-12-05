# == Schema Information
#
# Table name: equipments
#
#  id             :bigint           not null, primary key
#  imagen         :string
#  name           :string
#  specifications :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Laptop, Impresora, etc
class Equipment < ApplicationRecord
	mount_uploader :imagen, ImagenUploader

	validates :name, presence: true, uniqueness: {case_sensitive: true}

	def self.search_index(term)
		where('LOWER(name) LIKE :term OR LOWER(specifications) LIKE :term', term: "%#{term.downcase}%")
	end
end
