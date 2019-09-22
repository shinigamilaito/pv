=begin

Stores the information of
the printing quotations (invitations)

=end

# == Schema Information
#
# Table name: quotation_printings
#
#  id                         :bigint           not null, primary key
#  change                     :decimal(10, 2)   default(0.0)
#  cost_elaboration           :decimal(10, 2)   default(0.0)
#  cost_piece                 :decimal(10, 2)   default(0.0)
#  delivery_date              :string
#  description                :text
#  description_adjust_design  :text
#  difference                 :decimal(10, 2)   default(0.0)
#  draft_delivery_date        :string
#  full_payment               :boolean
#  imagen                     :string
#  number_folio               :string
#  paid_with                  :decimal(10, 2)   default(0.0)
#  payment                    :decimal(10, 2)   default(0.0)
#  printing_type              :string
#  status                     :string
#  ticket                     :integer          default(0)
#  total_cost                 :decimal(10, 2)   default(0.0)
#  total_pieces               :integer
#  total_quotations           :decimal(10, 2)   default(0.0)
#  utility                    :decimal(10, 2)   default(0.0)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  cash_opening_impression_id :bigint
#  client_id                  :bigint
#  content_for_invitation_id  :bigint
#  invitation_id              :bigint
#  payment_type_id            :bigint
#  user_id                    :bigint
#

class QuotationPrinting < ApplicationRecord
  mount_uploader :imagen, ImagenUploader

  belongs_to :invitation
  belongs_to :content_for_invitation
  belongs_to :client
  belongs_to :user
  # belongs_to :payment_type, optional: true
  # belongs_to :cash_opening_impression

  # has_many :printing_product_quotations # Revisar
  has_many :printing_product_quotation_printings, dependent: :destroy
  has_many :message_history_quotation_printings, dependent: :destroy
  has_many :printing_products, through: :printing_product_quotation_printings

  validates :client_id, :user_id, presence: true
  validates :number_folio, presence: true, uniqueness: {case_sensitive: true}

  before_validation :set_number_folio, unless: Proc.new { |model| model.persisted? }

  def set_number_folio
    self.number_folio = QuotationPrinting.count + 1
  end

=begin
  def set_number_ticket
    return QuotationPrinting.count + 1 # + PartialPaymentQuotationPrinting.count
  end

  def self.total(quotation_printings)
    return nil if quotation_printings.blank?

    quotation_printings
      .map {|quotation_printing| quotation_printing.payment }
      .sum
  end
=end

  def product_types=(printing_products)
    update_stock_printing_product(printing_products)
    printing_product_quotation_printings.clear

    printing_products.each do |printing_product|
      printing_product_id = printing_product[:printing_product_id]
      quantity = printing_product[:quantity].to_i

      if printing_product_id.present? && quantity > 0
        printing_product_quotation = PrintingProductQuotationPrinting.new({
            printing_product_id: printing_product_id,
            quantity: quantity
        })
        printing_product_quotation_printings << printing_product_quotation
      end
    end
  end

  def message=(message_history)
    if message_history.present?
      message_history_quotation_printings << MessageHistoryQuotationPrinting.new(message: message_history)
    end
  end

  def self.impression_types
    ["Laser"]
  end

  def printing_product_id_by(product_type)
    if new_record?
      nil
    else
      printing_product = printing_product_by(product_type)
      printing_product.nil? ? nil : printing_product.id
    end
  end

  def printing_product_image_url_by(product_type)
    if new_record?
      "default3.png"
    else
      printing_product = printing_product_by(product_type)
      printing_product.nil? ? "default3.png" : printing_product.imagen_url
    end
  end

  def printing_product_quantity_by(product_type)
    if new_record?
      0
    else
      printing_product = printing_product_by(product_type)
      if printing_product.nil?
        return 0
      else
        printing_product_quotation_printing = printing_product_quotation_printings
                                                  .where(printing_product_id: printing_product.id)
                                                  .first
        printing_product_quotation_printing.nil? ? 0 : printing_product_quotation_printing.quantity
      end
    end
  end

  def self.all_by_client(client)
        self
        .joins(:client)
        .where('LOWER(name) LIKE :term or LOWER(first_name) LIKE :term or LOWER(last_name) LIKE :term', term: "%#{client.downcase}%")
  end

  private

  def printing_product_by(product_type)
    printing_products.find_by_product_type(product_type)
  end

  def update_stock_printing_product(printing_products)
    printing_products.each do |printing_product|
      printing_product_id = printing_product[:printing_product_id]
      quantity = printing_product[:quantity].to_i

      if printing_product_id.present? && quantity > 0
        if self.draft_delivery_date.present? && payment_set?
          printing_product_quotation_printing = self.printing_product_quotation_printings.where(printing_product_id: printing_product_id.to_i).first
          if printing_product_quotation_printing.present?
            printing_product = printing_product_quotation_printing.printing_product
            printing_product.stock -= (quantity - printing_product_quotation_printing.quantity)
            printing_product.save
          else
            printing_product = PrintingProduct.find(printing_product_id)
            printing_product.stock -= quantity
            printing_product.save
          end
        end
      end
    end
  end

  def payment_set?
    return false unless self.payment.present?
    self.payment > 0
  end
end
