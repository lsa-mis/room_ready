# == Schema Information
#
# Table name: rovers
#
#  id         :bigint           not null, primary key
#  uniqname   :string
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Rover < ApplicationRecord
  validates :uniqname, presence: true, uniqueness: true
end
