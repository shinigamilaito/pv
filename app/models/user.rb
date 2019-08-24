# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :text
#  contact                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  rol_id                 :bigint           not null
#

class User < ApplicationRecord
  attr_accessor :admin, :sales_product, :sales_printing

  belongs_to :rol
  has_many :sale_products
  has_many :quotation_products
  has_many :printing_sale_products
  has_many :invitation_printing_products
  has_many :printing_product_quotations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable#, :validatable

  validates :name, :first_name, :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :contact, :address, presence: true

  def admin?
    rol.name == admin
  end

  def sales_product?
    rol.name == sales_product || admin?
  end

  def sales_printing?
    rol.name == sales_printing || admin?
  end

  def formal_name
    "#{name} #{first_name} #{last_name}"
  end

  def self.search(term)
    where('CONCAT(LOWER(name), LOWER(first_name), LOWER(last_name)) LIKE :term OR LOWER(username) LIKE :term OR LOWER(email) LIKE :term' , term: "%#{term.downcase}%")
  end

  def self.search_autocomplete(term)
    where('LOWER(name) LIKE :term or LOWER(first_name) LIKE :term or LOWER(last_name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  private

  def admin
    'Administrador'
  end

  def sales_product
    'Vendedor'
  end

  def sales_printing
    'Imprenta'
  end

end
