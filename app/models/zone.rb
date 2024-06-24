# == Schema Information
#
# Table name: zones
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Zone < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true
  has_many :buildings

  def rooms_checked_today
    RoomState.joins(room: { floor: { building: :zone } })
             .where('room_states.created_at >= ? AND zones.id = ?', Time.zone.now.beginning_of_day, self.id)
             .count
  end

  def total_rooms
    Room.joins(floor: { building: :zone })
        .where(zones: { id: self.id })
        .count
  end
  
end
