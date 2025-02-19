class Street < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
end
