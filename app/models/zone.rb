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

  def rooms_checked_today(selected_date)
    Room.joins(floor: { building: :zone })
        .includes(:room_states)
        .where(zones: { id: self.id })
        .select { |room| RoomStatus.new(room, selected_date).room_checked_today? && RoomStatus.new(room, selected_date).calculate_percentage.to_f == 100.0 }
        .count
  end

  def total_rooms
    Room.joins(floor: { building: :zone })
        .where(zones: { id: self.id })
        .count
  end
end
