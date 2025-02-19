class District < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
end
