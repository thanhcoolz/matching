# == Schema Information
#
# Table name: clubs
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(FALSE)
#  email         :string(255)      not null
#  name          :string(255)      not null
#  country_id    :integer          not null
#  city_id       :integer          not null
#  district_id   :integer          not null
#  street_id     :integer          not null
#  address       :string(255)      not null
#  description   :string(255)      not null
#  table_numbers :integer          default(1), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Club < ApplicationRecord
  # Thiết lập các quan hệ liên kết với các bảng khác
  belongs_to :country
  belongs_to :city
  belongs_to :district
  belongs_to :street

  has_many :club_managers, dependent: :destroy
  accepts_nested_attributes_for :club_managers, allow_destroy: true

  # Thiết lập lưu trữ ảnh sử dụng Active Storage
  has_one_attached :main_image
  has_many_attached :sub_images

  has_many :tables
  accepts_nested_attributes_for :tables, allow_destroy: true

  has_many :reservations

  # Các ràng buộc kiểm tra dữ liệu đầu vào
  validates :country_id, presence: true
  validates :city_id, presence: true
  validates :district_id, presence: true
  validates :street_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true, if: :presence

  # Kiểm tra hợp lệ cho ảnh đại diện và ảnh phụ
  validate :acceptable_main_image
  validate :acceptable_sub_images

  # Scope lấy các club đang hoạt động
  scope :is_active, -> { where(active: true) }

  # Trả về địa chỉ đầy đủ của club
  def full_address
    "#{district.name}, #{street.name}, #{address}"
  end

  # Class method lấy các club đang hoạt động
  def self.active
    where(active: true)
  end

  # Kiểm tra và tạo mới reservation cho player
  def check_and_create_reservation(player_id, reservation_params)
    Rails.logger.info "Creating reservation with params: #{reservation_params.inspect}"
    Rails.logger.info "Current player: #{player_id}"

    # Kiểm tra tham số reservation hợp lệ
    if reservation_params[:start_time].blank? || reservation_params[:duration_hours].blank?
      return { success: false, error: 'Invalid reservation parameters' }
    end

    start_time = reservation_params[:start_time].to_datetime
    if start_time <= Time.current
      return { success: false, error: 'Reservation must be for a future time' }
    end

    duration_hours = reservation_params[:duration_hours].to_i
    end_time = start_time + duration_hours.hours

    # Kiểm tra club có bàn trống trong khoảng thời gian yêu cầu không
    available = available_tables(start_time, end_time)

    if available.empty?
      return { success: false, error: 'No tables available for the requested time' }
    end

    # Tạo reservation với bàn đầu tiên còn trống
    reservation = reservations.new(
      player_id: player_id,
      table_id: available.first.id,
      start_time: start_time,
      end_time: end_time,
      duration_hours: duration_hours,
      reservation_type: reservation_params[:reservation_type],
      number_of_player: reservation_params[:number_of_player],
      status: :pending
    )

    if reservation.save
      { success: true, reservation: reservation }
    else
      { success: false, error: reservation.errors.full_messages.join(', ') }
    end
  rescue StandardError => e
    Rails.logger.error "Error creating reservation: #{e.message}"
    { success: false, error: 'An unexpected error occurred' }
  end

  # Lấy danh sách các bàn còn trống trong khoảng thời gian chỉ định
  def available_tables(start_time, end_time)
    tables.where.not(
      id: reservations
        .where(status: [:pending, :accepted])
        .where('start_time < ? AND end_time > ?', end_time, start_time)
        .select(:table_id)
    ).order(:id)
  end

  private

  # Kiểm tra tính hợp lệ của ảnh đại diện (main_image)
  def acceptable_main_image
    return unless main_image.attached?

    unless main_image.blob.content_type.in?(%w[image/jpeg image/png])
      errors.add(:main_image, "must be a JPEG or PNG")
    end

    unless main_image.blob.byte_size <= 5.megabytes
      errors.add(:main_image, "is too large (maximum is 5MB)")
    end
  end

  # Kiểm tra tính hợp lệ của các ảnh phụ (sub_images)
  def acceptable_sub_images
    return unless sub_images.attached?

    sub_images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png])
        errors.add(:sub_images, "must be a JPEG or PNG")
      end

      unless image.blob.byte_size <= 5.megabytes
        errors.add(:sub_images, "is too large (maximum is 5MB)")
      end
    end
  end
end