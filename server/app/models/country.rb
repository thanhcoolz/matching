class Country < ApplicationRecord
  # Associations
  has_many :cities
  has_many :clubs
  has_many :players
end
