# == Schema Information
#
# Table name: players
#
#  id              :bigint           not null, primary key
#  phone_number    :string(255)      not null
#  password_digest :string(255)      not null
#  username        :string(255)      not null
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

  enum gender: { male: 1, female: 2 }

  # Validations
  validates :phone_number, presence: true, uniqueness: true
  validates :username, :gender, :age, presence: true

  has_one_attached :avatar

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(avatar) : nil
  end

  has_many :reservations
  has_many :reservation_parties
  has_many :joined_reservations, through: :reservation_parties, source: :reservation

end
