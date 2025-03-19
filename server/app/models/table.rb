class Table < ApplicationRecord
  belongs_to :club
  has_many :reservations

  validates :name, presence: true
  validates :name, uniqueness: { scope: :club_id }

  before_create :set_default_name

  def set_default_name
    self.name = "Table #{club.tables.count + 1}"
  end
end
