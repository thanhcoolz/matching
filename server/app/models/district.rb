class District < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
  has_many :streets

  accepts_nested_attributes_for :streets
end
