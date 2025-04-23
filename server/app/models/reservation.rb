# == Schema Information
#
# Table name: reservations
#
#  id               :bigint           not null, primary key
#  club_id          :bigint           not null
#  player_id        :bigint           not null
#  table_id         :bigint           not null
#  start_time       :datetime         not null
#  end_time         :datetime         not null
#  duration_hours   :integer          default(2), not null
#  reservation_type :integer          default("private"), not null
#  status           :integer          default("pending"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Reservation < ApplicationRecord
  belongs_to :player
  belongs_to :club
  belongs_to :table
  has_many :reservation_parties, class_name: 'ReservationParty'
  has_many :players, through: :reservation_parties

  enum reservation_type: { private: 1, public: 2 }, _prefix: true
  enum status: { pending: 1, rejected: 2, canceled: 3, confirmed: 4, paid: 5 }
  
  validates :start_time, presence: true
  validates :duration_hours, presence: true
  validates :reservation_type, presence: true
  validates :status, presence: true
  validates :number_of_player, presence: true, if: :reservation_type_public?

  def reservation_type_public?
    reservation_type == 'public'
  end

  def end_time
    start_time + duration_hours.hours
  end
end
