# == Schema Information
#
# Table name: streets
#
#  id          :bigint           not null, primary key
#  district_id :bigint           not null
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Street < ApplicationRecord
  # Associations
  has_many :clubs
  has_many :players
end
