class Player < ApplicationRecord
  has_secure_password

  # Associations
  belongs_to :country
  belongs_to :city
  belongs_to :district
  belongs_to :street

  # Validations
  validates :country_id, presence: true
  validates :city_id, presence: true
  validates :district_id, presence: true
  validates :street_id, presence: true
end
