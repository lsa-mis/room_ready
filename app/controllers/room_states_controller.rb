class RoomStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room_state, only: %i[ show edit update destroy ]

  # GET /room_states or /room_states.json
  def index
    @room_states = RoomState.all
  end

  # GET /room_states/1 or /room_states/1.json
  def show
  end

  # GET /room_states/new
  def new
    @room_state = RoomState.new
  end

  # GET /room_states/1/edit
  def edit
  end

  # POST /room_states or /room_states.json
  def create
    @room_state = RoomState.new(room_state_params)

    respond_to do |format|
      if @room_state.save
        format.html { redirect_to room_state_url(@room_state), notice: "Room state was successfully created." }
        format.json { render :show, status: :created, location: @room_state }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_states/1 or /room_states/1.json
  def update
    respond_to do |format|
      if @room_state.update(room_state_params)
        format.html { redirect_to room_state_url(@room_state), notice: "Room state was successfully updated." }
        format.json { render :show, status: :ok, location: @room_state }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_states/1 or /room_states/1.json
  def destroy
    @room_state.destroy!

    respond_to do |format|
      format.html { redirect_to room_states_url, notice: "Room state was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_state
      @room_state = RoomState.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_state_params
      params.require(:room_state).permit(:checked_by, :is_accessed, :report_to_supervisor, :room_id)
    end
end
