# == Schema Information
#
# Table name: countries
#
#  id   :bigint           not null, primary key
#  name :string(255)      not null
#
class Country < ApplicationRecord
  # Associations
  has_many :cities
  has_many :clubs
  has_many :players
end
