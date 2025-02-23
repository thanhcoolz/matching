# == Schema Information
#
# Table name: club_managers
#
#  id              :bigint           not null, primary key
#  club_id         :integer          not null
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ClubManager < ApplicationRecord
  has_secure_password

  # Associations
  belongs_to :club

  # Validations
  validates :club_id, presence: true
  validates :username, presence: true
  validates :username, uniqueness: { scope: :club_id }
end
