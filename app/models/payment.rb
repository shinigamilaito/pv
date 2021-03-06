# == Schema Information
#
# Table name: payments
#
#  id                            :bigint           not null, primary key
#  payment_type_id               :bigint
#  worforce                      :decimal(10, 2)   default(0.0)
#  discount                      :decimal(10, 2)   default(0.0)
#  departure_date                :string
#  user_id                       :bigint
#  generic_price_id              :bigint
#  paid_with                     :decimal(10, 2)   default(0.0)
#  change                        :decimal(10, 2)   default(0.0)
#  ticket                        :integer          default(0)
#  service_id                    :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  paid                          :boolean          default(FALSE)
#  cash_opening_services_sale_id :bigint
#

# Pago realizado por el servicio
class Payment < ApplicationRecord
  belongs_to :payment_type, optional: true
  belongs_to :user, optional: true
  belongs_to :generic_price, optional: true
  belongs_to :service
  belongs_to :cash_opening_services_sale, optional: true

  has_many :service_spare_parts
  has_many :equipment_customers

  validates :paid_with, :change, presence: true

  def real_worforce
    if generic_price.present?
      generic_price.price
    else
      worforce
    end
  end

  def self.search(term)
    if term.to_i != 0
      Payment
        .joins(service: :client)
      	.where('payments.paid = ? AND services.number_folio = ?', true, term.to_i)
    else
      Payment.joins(service: :client)
        .where('payments.paid = ?', true)
        .where('CONCAT(LOWER(clients.name), LOWER(clients.first_name), LOWER(clients.last_name)) LIKE :term', term: "%#{term.downcase}%")
    end
 	end

  def cost
    paid_with - change
  end

  def self.total(payments)
    return nil if payments.blank?

    payments
      .map {|payment| payment.cost }
      .sum
  end
end
