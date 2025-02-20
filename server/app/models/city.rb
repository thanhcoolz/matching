class City < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
  has_many :districts

  accepts_nested_attributes_for :districts
end
