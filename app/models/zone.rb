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

  # def rooms_checked_today
  #   Room.joins(floor: { building: :zone })
  #       .includes(:room_states)
  #       .where(zones: { id: self.id })
  #       .select { |room| RoomStatus.new(room).room_checked_today? && RoomStatus.new(room).calculate_percentage.to_f == 100.0 }
  #       .count
  # end

  # def rooms_checked_for_date(selected_date)
  #   if selected_date.present?
  #     date = Date.parse(selected_date)
  #   else
  #     date = Date.today
  #   end
  #   RoomState.joins(room: { floor: { building: :zone } } )
  #            .where(zones: { id: self.id })
  #            .where(updated_at: date.beginning_of_day..date.end_of_day)
  #            .select { |room_state| true } # RoomStatus calculate_percentage
  #            .count

  # end

  # def total_rooms
  #   Room.joins(floor: { building: :zone })
  #       .where(zones: { id: self.id })
  #       .count
  # end
end
