class Party < ApplicationRecord
  # Associations
  belongs_to :captain, class_name: 'Player'
  belongs_to :club

  # Validations
  validates :captain_id, presence: true
  validates :club_id, presence: true
end
