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
  # Sử dụng bcrypt để mã hóa mật khẩu và xác thực
  has_secure_password

  # Thiết lập các quan hệ liên kết với các bảng khác
  belongs_to :country
  belongs_to :city
  belongs_to :district
  belongs_to :street

  # Enum cho giới tính (1: nam, 2: nữ)
  enum gender: { male: 1, female: 2 }

  # Ràng buộc dữ liệu: số điện thoại phải có và duy nhất, username, giới tính, tuổi phải có
  validates :phone_number, presence: true, uniqueness: true
  validates :username, :gender, :age, presence: true

  # Thiết lập lưu trữ avatar sử dụng Active Storage
  has_one_attached :avatar

  # Trả về URL của avatar nếu có, ngược lại trả về nil
  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(avatar) : nil
  end

  # Quan hệ với các bảng liên quan đến đặt bàn
  has_many :reservations
  has_many :reservation_parties
  has_many :joined_reservations, through: :reservation_parties, source: :reservation

end