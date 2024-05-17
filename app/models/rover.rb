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
  validates_presence_of :uniqname
  validates :uniqname, uniqueness: true
end
