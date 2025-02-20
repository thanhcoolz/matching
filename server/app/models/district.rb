# == Schema Information
#
# Table name: districts
#
#  id         :bigint           not null, primary key
#  city_id    :bigint           not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class District < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
  has_many :streets

  accepts_nested_attributes_for :streets
end
