# == Schema Information
#
# Table name: tables
#
#  id         :bigint           not null, primary key
#  club_id    :bigint           not null
#  name       :string(255)      not null
#  is_active  :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Table < ApplicationRecord
  belongs_to :club
  has_many :reservations

  validates :name, presence: true
  validates :name, uniqueness: { scope: :club_id }
end
