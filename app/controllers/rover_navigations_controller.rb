class RoverNavigationsController < ApplicationController
  before_action :auth_user

  def zones
    authorize :rover_navigation, :zones?
    @zones = Zone.includes(:buildings).order(:name)
  end

  def buildings
    authorize :rover_navigation, :buildings?

    @zone = Zone.find(params[:zone_id])
    @buildings = @zone.buildings.includes(:floors).order(:name)

    if params[:search].present?
      @buildings = @buildings.where("name ILIKE :search OR address ILIKE :search", search: "%#{params[:search]}%")
    end
  end

  def rooms
    authorize :rover_navigation, :rooms?
    @floor = Floor.find(params[:floor_id])
    @rooms = @floor.rooms.order(:room_number)

    if params[:search].present?
      @rooms = @rooms.where("room_number ILIKE :search", search: "%#{params[:search]}%")
    end
  end

  def confirmation
    authorize :rover_navigation, :confirmation?
    @room_id = params[:room_id]
    @room = Room.find(@room_id)
 
    if @room.nil?
      redirect_to zones_rover_navigation_path, notice: 'Room does not exist!'
    end

    @room_state_today = @room.room_state_for_today

    if @room_state_today.nil?
      redirect_to zones_rover_navigation_path, notice: 'Room not checked or Invalid!'
    end

    rooms_in_same_floor = rooms_on_same_floor_except_current(@room)
    room_in_nearby_floor = room_on_nearest_floor(@room)
    @recommended_room = nil

    unless rooms_in_same_floor.nil?
      start_of_day = Time.now.beginning_of_day
      end_of_day = Time.now.end_of_day

      rooms_with_no_check_time = rooms_in_same_floor.where(last_time_checked: nil)

      if rooms_with_no_check_time.exists?
        rooms_not_checked = rooms_with_no_check_time
      else
        rooms_not_checked = @rooms_in_same_floor.where(last_time_checked: start_of_day..end_of_day)
      end

      rooms_not_checked_ordered = rooms_not_checked.order(:room_number).pluck(:room_number)
      closest_room_to_current = closest_room(rooms_not_checked_ordered, @room.room_number) 
      @recommended_room = Room.find_by(room_number: closest_room_to_current)
      return @recommended_room
    end

    unless room_in_nearby_floor.nil?
      @recommended_room = room_in_nearby_floor
      return @recommended_room
    end
  end

  private
    def rooms_on_same_floor_except_current(room)
      same_floor_rooms = room.floor.rooms.where.not(id: room.id)
      same_floor_rooms.exists? ? same_floor_rooms : nil
    end

    def room_on_nearest_floor(room)
      building = room.floor.building
      nearby_floors = building.floors.where.not(id: room.floor.id)
      
      start_of_day = Time.now.beginning_of_day
      end_of_day = Time.now.end_of_day

      if nearby_floors.exists?
        sorted_floor_names = sort_floors(nearby_floors.pluck(:name))

        sorted_floor_names.each do |floor_name|
          rooms_for_floor = nearby_floors.find_by(name: floor_name)&.rooms
          next if !(rooms_for_floor.present?)

          rooms_with_no_check_time = rooms_for_floor.where(last_time_checked: nil)

          if rooms_with_no_check_time.exists?
            return rooms_with_no_check_time.first
          else
            rooms_not_checked = rooms_for_floor.where(last_time_checked: start_of_day..end_of_day)

            if rooms_not_checked.exists?
              return rooms_not_checked.first
            end
          end
        end
      end
      nil
    end

    def closest_room(rooms_list, room_just_checked)
      target_int = room_just_checked.to_i
      int_array = rooms_list.map(&:to_i)
      closest = int_array.min_by { |num| (num - target_int).abs }
      closest.to_s
    end
end
