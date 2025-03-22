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

  enum reservation_type: { private: 1, public: 2 }, _prefix: true
  enum status: { pending: 1, accepted: 2, rejected: 3, canceled: 4 }

  validates :start_time, presence: true
  validates :duration_hours, presence: true
  validates :reservation_type, presence: true
  validates :status, presence: true

  def end_time
    start_time + duration_hours.hours
  end
end
