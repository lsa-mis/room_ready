class Recommendation
  def sort_floors(floors)
    sorted = floors.sort_by do |s|
      if s =~ /^\d+$/
        [2, $&.to_i]
      else
        [1, s]
      end
    end
    return sorted
  end
  
  def initialize(room)
    @room = room
    @building = @room.floor.building
    @room_status = RoomStatus.new(@room)
    @start_of_day = Time.now.beginning_of_day
    @end_of_day = Time.now.end_of_day
  end

  def all_rooms_on_same_floor
    same_floor_rooms = @room.floor.rooms.order(:room_number)
    same_floor_rooms.exists? ? same_floor_rooms : nil
  end

  def all_unchecked_rooms
    unchecked_rooms = []

    all_rooms_on_same_floor.each do |room|
      specific_room_status = RoomStatus.new(room)
      unless specific_room_status.room_checked_once?
        unchecked_rooms << room
        next
      end

      unless specific_room_status.room_checked_today?
        unchecked_rooms << room
      end
    end

    unchecked_rooms = unchecked_rooms.pluck(:room_number)
  end

  def all_floors
    floors = @room.floor.building.floors
    sorted_floor_names = sort_floors(floors.pluck(:name))
  end

  def floor_has_unchecked_rooms?(floor)
    floor.rooms.each do |room|
      unless RoomStatus.new(room).room_state_today.present?
        return true
      end
    end
    false
  end

  def unchecked_rooms_on_floor(floor)
    unchecked_rooms = []
    rooms_with_no_check_time = floor.rooms.where(last_time_checked: nil)

    if rooms_with_no_check_time.exists?
      unchecked_rooms += rooms_with_no_check_time
    end

    rooms_not_checked = floor.rooms.where.not(last_time_checked: @start_of_day..@end_of_day)

    if rooms_not_checked.exists?
      unchecked_rooms += rooms_not_checked
    end

    unchecked_rooms
  end

  def recommend_room
    if all_unchecked_rooms.present?
      return Room.find_by(room_number: closest_room, floor_id: @room.floor.id)
    else
      all_floors.delete(@room.floor.name)
      all_floors.each do |floor_name|
        floor = @building.floors.find_by(name: floor_name)
        if floor_has_unchecked_rooms?(floor)
          return unchecked_rooms_on_floor(floor).first
        end
      end
    end
    false
  end

  def closest_room
    target_int = @room.room_number.gsub(/\D/, '').to_i
    room_pairs = all_unchecked_rooms.map { |room| [room, room.gsub(/\D/, '').to_i] }
    closest_room = room_pairs.min_by { |room, num| (num - target_int).abs }
    closest_room[0]
  end
end