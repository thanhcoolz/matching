# == Schema Information
#
# Table name: clubs
#
#  id          :bigint           not null, primary key
#  name        :string(255)      not null
#  country_id  :integer          not null
#  city_id     :integer          not null
#  district_id :integer          not null
#  street_id   :integer          not null
#  address     :string(255)      not null
#  description :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Club < ApplicationRecord
  # Associations
  belongs_to :country
  belongs_to :city
  belongs_to :district
  belongs_to :street
  has_many :club_managers

  # Validations
  validates :country_id, presence: true
  validates :city_id, presence: true
  validates :district_id, presence: true
  validates :street_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true
end
