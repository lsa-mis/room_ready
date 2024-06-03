class Floors::RoomsController < ApplicationController
  before_action :auth_user
  before_action :set_building_and_floor
  before_action :set_room, only: %i[ edit update destroy ]

  # GET /rooms/new
  def new
    @room = Room.new
    authorize @room
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)
    @room.floor_id = params[:floor_id]
    authorize @room

    respond_to do |format|
      if @room.save
        format.html { redirect_to zone_building_path(@building.zone, @building), notice: "Room was successfully created to the floor." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to room_url(@room), notice: "Room was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
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

    def set_building_and_floor
      @building = Building.find(params[:building_id])
      @floor = Floor.find(params[:floor_id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:rmrecnbr, :room_number, :room_type, :facility_id, :floor_id)
    end
end
