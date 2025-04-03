class ReservationsParty < ApplicationRecord
  belongs_to :reservation
  belongs_to :player

  validates :reservation_id, uniqueness: { scope: :player_id, message: "already has a party record for this player" }
  validates :is_host, inclusion: { in: [true, false] }
end