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
#  archived          :boolean          default(FALSE)
#
class Room < ApplicationRecord
  belongs_to :floor
  has_many :resources
  has_many :room_tickets
  has_many :active_specific_attributes, -> { active }, class_name: 'SpecificAttribute'
  has_many :archived_specific_attributes, -> { archived }, class_name: 'SpecificAttribute'
  has_many :room_states
  has_many :notes

  validates :rmrecnbr, presence: true, uniqueness: true
  validates :room_number, :room_type, presence: true

  accepts_nested_attributes_for :specific_attributes

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def full_name
    archived = self.archived ? " - archived" : ""
    [floor.building.nick_name, room_number, archived].join(' ')
  end

  def room_state?
    RoomState.find_by(room_id: self).present?
  end

end
