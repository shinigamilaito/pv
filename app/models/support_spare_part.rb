# Managed the spare_parts used in supports
class SupportSparePart < ApplicationRecord
	belongs_to :support

	def self.create_spare_parts_used(spare_parts) 
		support_spare_parts = []
		spare_parts.each do |spare_part|
			support_spare_part = SupportSparePart.new
			support_spare_part.name = spare_part.name
			support_spare_part.description = spare_part.description
			support_spare_part.price = spare_part.price
			support_spare_part.quantity = 1	
			support_spare_parts << support_spare_part
		end

		return support_spare_parts
	end



end