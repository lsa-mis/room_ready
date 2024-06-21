class Rooms::RoomStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room
  before_action :set_room_state, only: %i[ show edit update destroy ]

  # GET /room_states or /room_states.json
  def index
    @room_states = RoomState.all.where(room_id: @room.id)
    authorize @room_states
  end

  # GET /room_states/1 or /room_states/1.json
  def show
  end

  # GET /room_states/new
  def new
    @room_state = RoomState.new
    authorize @room_state
    @rovers_form_announcement = Announcement.find_by(location: "rovers_form")
    @user = current_user
    
  end

  # GET /room_states/1/edit
  def edit
    authorize @room_state
    @rovers_form_announcement = Announcement.find_by(location: "rovers_form")
  end

  # POST /room_states or /room_states.json
  def create
    @room_state = @room.room_states.new(room_state_params)
    @room_state.checked_by = current_user.uniqname
    authorize @room_state
    respond_to do |format|
      if @room_state.save
        unless @room.update(last_time_checked: DateTime.now)
          flash.now['alert'] = "Error updating room record"
          return
        end
        notice = "A new state to this room was successfully created."
        format.html { redirect_to new_common_attribute_state_path(room_state_id: @room_state.id), notice: notice }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_states/1 or /room_states/1.json
  def update
    respond_to do |format|
      if @room_state.update(room_state_params)
        unless @room.update(last_time_checked: DateTime.now)
          flash.now['alert'] = "Error updating room record"
          return
        end
        if @room_state.common_attribute_states.any?
          format.html { redirect_to edit_common_attribute_state_path(room_state_id: @room_state.id), notice: "Room state was successfully updated." }
        else
          format.html { redirect_to new_common_attribute_state_path(room_state_id: @room_state.id), notice: "Room state was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
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
    def set_room
      @room = Room.find(params[:room_id])
      @no_access_reasons = AppPreference.find_by(name: 'no_access_reason_pref')&.value&.split(',').map(&:strip)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_room_state
      @room_state = RoomState.find(params[:id])
      authorize @room_state
      @user = current_user
    end

    # Only allow a list of trusted parameters through.
    def room_state_params
      params.require(:room_state).permit(:checked_by, :is_accessed, :report_to_supervisor, :no_access_reason, :room_id)
    end
end
