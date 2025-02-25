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

  # active storage
  has_one_attached :main_image
  has_many_attached :sub_images

  # Validations
  validates :country_id, presence: true
  validates :city_id, presence: true
  validates :district_id, presence: true
  validates :street_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true

  # Image validations
  validate :acceptable_main_image
  validate :acceptable_sub_images

  def full_address
    "#{district.name}, #{street.name}, #{address}"
  end

  private

  def acceptable_main_image
    return unless main_image.attached?

    unless main_image.blob.content_type.in?(%w[image/jpeg image/png])
      errors.add(:main_image, "must be a JPEG or PNG")
    end

    unless main_image.blob.byte_size <= 5.megabytes
      errors.add(:main_image, "is too large (maximum is 5MB)")
    end
  end

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
