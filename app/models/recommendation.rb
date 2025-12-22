class Recommendation
  include FloorSortable
  
  def initialize(room)
    @room = room
    @building = @room.floor.building
    @room_status = RoomStatus.new(@room)
    @start_of_day = Time.now.beginning_of_day
    @end_of_day = Time.now.end_of_day
  end

  def sort_floor_objects_by_name(floors)
    sort_floors(floors)
  end

  def sort_floor_names(floors_names_array)
    sort_floors(floors_names_array)
  end

  def all_floors
    floors = @room.floor.building.floors
    sort_floor_objects_by_name(floors)
  end

  def all_rooms_in_building
    floors = @building.floors
    floors_by_name = floors.index_by(&:name)
    sorted_floor_names = sort_floor_names(floors_by_name.keys)
    
    sorted_floor_names.flat_map do |floor_name|
      floor = floors_by_name[floor_name]
      floor.active_rooms.sort_by(&:room_number)
    end
  end

  def unchecked_rooms_in_building
    floors = @building.floors
    floors_by_name = floors.index_by(&:name)
    sorted_floor_names = sort_floor_names(floors_by_name.keys)
    unchecked_rooms = []
    sorted_floor_names.each do |floor_name|
      floor = floors_by_name[floor_name]
      next unless floor
      unchecked_rooms.concat(unchecked_rooms_on_floor(floor))
    end
    unchecked_rooms
  end

  def unchecked_rooms_and_current_room
    rooms = unchecked_rooms_in_building
    unless rooms.include?(@room)
      all_rooms = all_rooms_in_building
      current_room_index = all_rooms.index(@room)
      
      # Find the correct position to insert @room
      insert_position = rooms.find_index { |room| all_rooms.index(room) > current_room_index } || rooms.length
      rooms.insert(insert_position, @room)
    end
    rooms
  end

  def unchecked_rooms_on_floor(floor)
    unchecked_rooms = []
    rooms_with_no_check_time = floor.active_rooms.where(last_time_checked: nil)

    if rooms_with_no_check_time.exists?
      unchecked_rooms += rooms_with_no_check_time
    end

    rooms_not_checked = floor.active_rooms.where.not(last_time_checked: @start_of_day..@end_of_day)

    if rooms_not_checked.exists?
      unchecked_rooms += rooms_not_checked
    end
    unchecked_rooms
  end


  def next_room
    return nil if unchecked_rooms_in_building.empty?

    rooms = unchecked_rooms_and_current_room
    current_index = rooms.index(@room)
    
    return nil if current_index.nil?
    
    next_index = (current_index + 1) % rooms.length
    rooms[next_index]
  end

  def previous_room
    return nil if unchecked_rooms_in_building.empty?
    
    rooms = unchecked_rooms_and_current_room
    current_index = rooms.index(@room)
    
    return nil if current_index.nil?
    
    previous_index = (current_index - 1) % rooms.length
    rooms[previous_index]
  end

end
