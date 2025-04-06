# == Schema Information
#
# Table name: reservations_parties
#
#  id             :bigint           not null, primary key
#  reservation_id :bigint           not null
#  player_id      :bigint           not null
#  is_host        :boolean          default: false
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ReservationParty < ApplicationRecord
  self.table_name = 'reservations_parties'
  
  belongs_to :reservation
  belongs_to :player

  validates :reservation_id, presence: true
  validates :player_id, presence: true
  validates :player_id, uniqueness: { scope: :reservation_id, message: "already has a party record for this player" }
  validates :is_host, inclusion: { in: [true, false] }
end