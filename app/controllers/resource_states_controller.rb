class ResourceStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room_state, only: %i[ new ]

  # GET /resource_states/new
  def new
    @resources = Resource.where(room_id: @room)

    authorize @resources
    #defaults to /resource_states
    @resource_state = ResourceState.new

  end

  # POST /resource_states or /resource_states.json
  def create

    @resource_state = ResourceState.new(resource_state_params)
    authorize @resource_state
    respond_to do |format|
      if @resource_state.save
        @room = Room.find(params[:room_id])

        @room_state = RoomState.find(params[:room_state_id])
        format.html { redirect_to resource_state_url, notice: "Resource state was saved." }


      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end

  end

  private

    def set_room_state
      @room = Room.find(params[:room_id])

      @room_state = RoomState.find(params[:room_state_id])
      authorize ResourceState
    end

    # Only allow a list of trusted parameters through.
    def resource_state_params

      params.require(:resource_state).permit(:room_state_id, :is_checked, :resource_id)
      end
  end

