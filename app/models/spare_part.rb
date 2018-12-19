class SparePart < ApplicationRecord

  def self.search(term)
    where('LOWER(name) LIKE :term or LOWER(description) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.costs_totals_in_this(spare_parts)
  	total_cost = BigDecimal("0.00")

  	spare_parts.each do |spare_part|
  		total_cost += BigDecimal(spare_part.price)
  	end

  	return total_cost
  end
  
end
