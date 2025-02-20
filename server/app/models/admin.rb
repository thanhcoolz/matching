# == Schema Information
#
# Table name: admins
#
#  id              :bigint           not null, primary key
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Admin < ApplicationRecord
  has_secure_password

  # Validations
  validates :email, presence: true
  validates :password, presence: true
end
