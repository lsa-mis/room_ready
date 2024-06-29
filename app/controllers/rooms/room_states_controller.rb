class Rooms::RoomStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room
  before_action :set_room_state, only: %i[ show edit update destroy ]
  before_action :set_notes_andannouncements, only: %i[new edit create]

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
  end

  # GET /room_states/1/edit
  def edit
    authorize @room_state
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

        if @room_state.is_accessed?
          format.html { redirect_to redirect_rover_to_correct_state_new(@room, @room_state, "room") }
          format.json { render json: { status: 'ok' }, status: :ok }
        else
          format.html { redirect_to confirmation_rover_navigation_path(room_id: @room.id), notice: 'Room was successfully checked!' }
          format.json { render json: { status: 'ok' }, status: :ok }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @room_state.errors.full_messages }, status: :unprocessable_entity }
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
        if @room_state.is_accessed?
          format.html { redirect_to redirect_rover_to_correct_state_edit(@room, @room_state, "room") }
          format.json { render json: { status: 'ok' }, status: :ok }
        else
          format.html { redirect_to confirmation_rover_navigation_path(room_id: @room.id), notice: 'Room was successfully checked!' }
          format.json { render json: { status: 'ok' }, status: :ok }
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
      if AppPreference.find_by(name: 'no_access_reason').value.present?
        @no_access_reasons = AppPreference.find_by(name: 'no_access_reason')&.value&.split(',').map(&:strip)
      else
        @no_access_reasons = []
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_room_state
      @room_state = RoomState.find(params[:id])
      authorize @room_state
    end

    def set_notes_andannouncements
      @rovers_form_announcement = Announcement.find_by(location: "rovers_form")
      @notes = @room.notes.order("created_at DESC")
    end

    # Only allow a list of trusted parameters through.
    def room_state_params
      params.require(:room_state).permit(:checked_by, :is_accessed, :report_to_supervisor, :no_access_reason, :room_id)
    end
end
