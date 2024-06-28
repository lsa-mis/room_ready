# == Schema Information
#
# Table name: rooms
#
#  id                :bigint           not null, primary key
#  rmrecnbr          :string
#  room_number       :string
#  room_type         :string
#  floor_id          :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  last_time_checked :datetime
#
class Room < ApplicationRecord
  belongs_to :floor
  has_many :resources
  has_many :room_tickets
  has_many :specific_attributes
  has_many :room_states
  has_many :notes

  validates :rmrecnbr, presence: true, uniqueness: true
  validates :room_number, :room_type, presence: true

  accepts_nested_attributes_for :specific_attributes

  def full_name
    [floor.building.nick_name, room_number].join(' ')
  end

end
