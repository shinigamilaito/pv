class User < ApplicationRecord
  belongs_to :rol
  has_many :sale_products

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
