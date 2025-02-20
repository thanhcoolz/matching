# == Schema Information
#
# Table name: party_participants
#
#  id        :bigint           not null, primary key
#  party_id  :integer          not null
#  player_id :integer          not null
#
class PartyParticipant < ApplicationRecord
  # Associations
  belongs_to :party
  belongs_to :player

  # Validations
  validates :party_id, presence: true
  validates :player_id, presence: true
end
