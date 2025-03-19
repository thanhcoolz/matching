class Reservation < ApplicationRecord
  belongs_to :player
  belongs_to :club
  belongs_to :table
end
