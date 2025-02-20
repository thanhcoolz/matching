# == Schema Information
#
# Table name: parties
#
#  id         :bigint           not null, primary key
#  captain_id :integer          not null
#  club_id    :integer          not null
#
class Party < ApplicationRecord
  # Associations
  belongs_to :captain, class_name: 'Player'
  belongs_to :club

  # Validations
  validates :captain_id, presence: true
  validates :club_id, presence: true
end
