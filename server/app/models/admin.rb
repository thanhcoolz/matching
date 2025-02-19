class Admin < ApplicationRecord
  # Validations
  validates :email, presence: true
  validates :password, presence: true
  validates :role, presence: true
end
