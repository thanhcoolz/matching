# == Schema Information
#
# Table name: nearby_parties
#
#  id        :bigint           not null, primary key
#  player_id :integer          not null
#  party_id  :integer          not null
#  distance  :integer          not null
#
class NearbyParty < ApplicationRecord
  # Associations
  belongs_to :player
  belongs_to :party

  # Validations
  validates :player_id, presence: true
  validates :party_id, presence: true
  validates :distance, presence: true
end
