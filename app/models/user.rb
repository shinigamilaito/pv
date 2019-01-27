class User < ApplicationRecord
  belongs_to :rol

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable#, :validatable

  validates :name, :first_name, :username, :email, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create

  def admin?
    rol.name == "Administrador"
  end

  def formal_name
    "#{name} #{first_name} #{last_name}"
  end

end
