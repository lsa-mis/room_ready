class RoverNavigationsController < ApplicationController
  before_action :auth_user

  def zones
    authorize :rover_navigation, :zones?
    @zones = Zone.all.order(:name)
  end

  def buildings
    authorize :rover_navigation, :buildings?

    @zone = Zone.find(params[:zone_id])
    @buildings = @zone.buildings.order(:name)

    if params[:search].present?
      @buildings = @buildings.where("name ILIKE :search OR address ILIKE :search", search: "%#{params[:search]}%")
    end
  end

  def rooms
    authorize :rover_navigation, :rooms?
    @floor = Floor.find(params[:floor_id])
    @rooms = @floor.active_rooms.order(:room_number)

    if params[:search].present?
      @rooms = @rooms.where("room_number ILIKE :search", search: "%#{params[:search]}%")
    end
  end

  def redirect_to_unchecked_form
    room = Room.find(params[:id])
    authorize :rover_navigation
    room_state = RoomStatus.new(room).room_state_today
    if room_state.common_attribute_states.any?
      if room_state.specific_attribute_states.any?
        if room_state.resource_states.any?
        else
          redirect_to redirect_rover_to_correct_state(room: room, room_state: room_state, step: "specific_attributes", mode: "new") 
        end 
      else 
        redirect_to redirect_rover_to_correct_state(room: room, room_state: room_state, step: "common_attributes", mode: "new")
      end
    else
      redirect_to redirect_rover_to_correct_state(room: room, room_state: room_state, step: "room", mode: "new")
    end
  end

  def confirmation
    authorize :rover_navigation, :confirmation?
    @room = Room.find(params[:room_id])
 
    if @room.nil?
      redirect_to zones_rover_navigation_path, notice: 'Room does not exist!'
    end

    @room_state_today = RoomStatus.new(@room).room_state_today

    if @room_state_today.nil?
      redirect_to zones_rover_navigation_path, notice: 'Room not checked or Invalid!'
    end
    r = Recommendation.new(@room)
    @building_floors = r.all_floors
    @next_room = r.next_room
    @previous_room = r.previous_room
  end
end
