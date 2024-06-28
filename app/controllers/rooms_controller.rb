class RoomsController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ show destroy ]
  include BuildingApi

  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all.order(:room_number)
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
    @room.destroy!

    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])

      authorize @room
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:rmrecnbr, :room_number, :room_type, :floor_id)
    end
end
