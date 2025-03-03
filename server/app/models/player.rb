# == Schema Information
#
# Table name: players
#
#  id              :bigint           not null, primary key
#  phone_number    :string(255)      not null
#  password_digest :string(255)      not null
#  age             :integer          not null
#  gender          :integer          not null
#  country_id      :integer          not null
#  city_id         :integer          not null
#  district_id     :integer          not null
#  street_id       :integer          not null
#
class Player < ApplicationRecord
  has_secure_password

  # Associations
  belongs_to :country
  belongs_to :city
  belongs_to :district
  belongs_to :street

  # Validations
  validates :country_id, presence: true
  validates :city_id, presence: true
  validates :district_id, presence: true
  validates :street_id, presence: true
end
