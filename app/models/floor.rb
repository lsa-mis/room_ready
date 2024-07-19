# == Schema Information
#
# Table name: floors
#
#  id          :bigint           not null, primary key
#  name        :string
#  building_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Floor < ApplicationRecord
  belongs_to :building
  has_many :rooms
  has_many :active_rooms, -> { active }, class_name: 'Room'
  has_many :archived_rooms, -> { archived }, class_name: 'Room'

  validates :name, presence: true
end
