class RoomsController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ show destroy archive unarchive ]
  include BuildingApi

  # GET /rooms or /rooms.json
  def index
    @rooms = Room.active.order(:room_number)
    authorize @rooms
  end

  # GET /rooms/1 or /rooms/1.json
  def show
    @common_attributes = CommonAttribute.all
    @new_note = Note.new(room: @room)
    @notes = @room.notes.order("created_at DESC")
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @building = Building.find(params[:building_id])
    authorize @room
  end

  # POST /rooms or /rooms.json
  def create
    @building = Building.find(params[:building_id])
    rmrecnbr = room_params[:rmrecnbr]
    @room = Room.new(rmrecnbr: rmrecnbr)
    authorize @room
    bldrecnbr = @building.bldrecnbr
    result = get_room_info_by_rmrecnbr(bldrecnbr, rmrecnbr)
    if result['success']
      room_data = result['data']
      if Floor.find_by(name: room_data["FloorNumber"], building: @building).present?
        @floor = Floor.find_by(name: room_data["FloorNumber"], building: @building)
      else
       @floor = Floor.new(name: room_data["FloorNumber"], building: @building)
       @floor.save
      end
      @room = Room.new(rmrecnbr: room_data["RoomRecordNumber"], room_number: room_data["RoomNumber"], room_type: room_data["RoomTypeDescription"], floor: @floor)
      authorize @room
      if @room.save
        redirect_to building_path(@building), notice: "Room was successfully added to " + @floor.name + " floor."
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = result['error']
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    if @room.room_states.present?
      flash.now['alert'] = "The rooms has checked states - archive this room instead"
      @rooms = Room.active.order(:name)
    else
      @building = @room.floor.building
      if delete_room(@room)
        redirect_to building_path(@building), notice: "The room was deleted."
      else
        flash.now['alert'] = "error deleting room"
      end
    end
  end

  def archive
    session[:return_to] = request.referer
    if @room.update(archived: true)
      @rooms = Room.active.order(:name)
      redirect_back_or_default(notice: "The room was archived")
    else
      @rooms = Room.active.order(:name)
    end
  end

  def unarchive
    session[:return_to] = request.referer
    @archived = true
    if @room.update(archived: false)
      @rooms = Room.archived.order(:name)
      redirect_back_or_default(notice: "The room was unarchived")
    else
      @rooms = Room.archived.order(:name)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])

      authorize @room
    end

    def delete_room(room)
      begin
        Resource.where(room_id: room.id).delete_all
        SpecificAttribute.where(room_id: room.id).delete_all
        Note.where(room_id: room.id).delete_all
        floor = room.floor
        if room.delete
          unless floor.rooms.present?
            floor.delete
          end
          return true
        else
          return false
        end
      rescue StandardError => e
        raise ActiveRecord::Rollback
        return false
      end
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:rmrecnbr, :room_number, :room_type, :floor_id, :archived)
    end
end
