class ResourceStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create edit update_resource_states]

  # GET /resource_states/new
  def new
    authorize ResourceState

    @resource_states = @room.resources.all.map do |resource|
      resource.resource_states.new
    end
  end

  def edit
    @resource_states = @room_state.resource_states
    authorize @resource_states
  end

  # POST /resource_states or /resource_states.json
  def create
    authorize ResourceState

    @resource_states = resource_state_params.map do |res_params|
      @room_state.resource_states.new(res_params)
    end

    transaction = ActiveRecord::Base.transaction do
      @resource_states.each do |res|
        raise ActiveRecord::Rollback unless res.save
      end
      raise ActiveRecord::Rollback unless @room.update(last_time_checked: DateTime.now)
      true
    end

    if transaction
      redirect_to confirmation_rover_navigation_path(room_id: @room.id), notice: 'Room was successfully checked!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_resource_states
    authorize ResourceState
    @resource_states = resource_state_params.map do |cas_params|
      params = cas_params.except(:resource_state_id)
      resource_state = ResourceState.find(cas_params[:resource_state_id])
      resource_state.assign_attributes(params)
      resource_state
    end
  
    transaction = ActiveRecord::Base.transaction do
      @resource_states.each do |cas|
        raise ActiveRecord::Rollback unless cas.save
      end
      raise ActiveRecord::Rollback unless @room.update(last_time_checked: DateTime.now)
      true
    end
  
    if transaction
      redirect_to confirmation_rover_navigation_path(room_id: @room.id), notice: 'Room was successfully checked!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room_state = RoomState.find(params[:room_state_id])
    @room = @room_state.room
    @resource_form_announcement = Announcement.find_by(location: "resource_form")
    unless @room
      redirect_to rooms_path, alert: 'Room doesnt exist.' and return
    end

  end

  # Only allow a list of trusted parameters through.
  def resource_state_params
    params.require(:resource_states).values.map do |res_param|
      res_param.permit(:is_checked, :room_state_id, :resource_id, :resource_state_id)
    end
  end
end
