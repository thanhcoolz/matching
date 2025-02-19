class Admin < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: true
  validates :password, presence: true
  validates :role, presence: true
end
