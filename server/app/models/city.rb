# == Schema Information
#
# Table name: cities
#
#  id         :bigint           not null, primary key
#  country_id :bigint           not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class City < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
  has_many :districts

  accepts_nested_attributes_for :districts
end
