# == Schema Information
#
# Table name: clients
#
#  id           :bigint           not null, primary key
#  name         :string
#  first_name   :string
#  last_name    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :text
#  mobile_phone :string
#  home_phone   :string
#  email        :string
#

class Client < ApplicationRecord
	validates :name, uniqueness: {case_sensitive: true, scope: :first_name }
	validates :first_name, presence: true

	def self.search(term)
    where('LOWER(name) LIKE :term or LOWER(first_name) LIKE :term or LOWER(last_name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

	def formal_name
		"#{name} #{first_name} #{last_name}"
	end
end
