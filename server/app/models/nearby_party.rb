class NearbyParty < ApplicationRecord
  # Associations
  belongs_to :player
  belongs_to :party

  # Validations
  validates :player_id, presence: true
  validates :party_id, presence: true
  validates :distance, presence: true
end
