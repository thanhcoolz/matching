class ClubManager < ApplicationRecord
  # Associations
  belongs_to :club

  # Validations
  validates :club_id, presence: true
  validates :role, presence: true
end
