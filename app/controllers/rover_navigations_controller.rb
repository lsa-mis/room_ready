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
    @room = Room.find(params[:room_id])
 
    if @room.nil?
      redirect_to zones_rover_navigation_path, notice: 'Room does not exist!'
    end

    @room_state_today = RoomStatus.new(@room).room_state_today

    if @room_state_today.nil?
      redirect_to zones_rover_navigation_path, notice: 'Room not checked or Invalid!'
    end

    r = Recommendation.new(@room)
    @recommended_room = r.recommend_room
  end
end
