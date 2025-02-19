class PartyParticipant < ApplicationRecord
  # Associations
  belongs_to :party
  belongs_to :player

  # Validations
  validates :party_id, presence: true
  validates :player_id, presence: true
end
