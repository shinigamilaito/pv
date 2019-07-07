# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string           default(""), not null
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  rol_id                 :bigint           not null
#  username               :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  address                :text
#  contact                :string
#

class User < ApplicationRecord
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
  validates :username, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :contact, :address, presence: true

  def admin?
    rol.name == "Administrador"
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

end
