class ResourceStatesController < ApplicationController
  before_action :auth_user
  before_action :set_resource_state, only: %i[ edit ]
  before_action :set_room, only: %i[ new create ]

  # GET /resource_states/new
  def new
    authorize ResourceState

    @resource_states = @room.resources.all.map do |resource|
      resource.resource_states.new
    end
  end

  def edit
  end

  # POST /resource_states or /resource_states.json
  def create
    authorize ResourceState

    @room_state = @room.room_state_for_today
    @resource_states = resource_state_params.map do |res_params|
      @room_state.resource_states.new(res_params)
    end

    ActiveRecord::Base.transaction do
      @resource_states.each do |res|
        raise ActiveRecord::Rollback unless res.save
      end
    end

    if @resource_states.all?(&:persisted?)
      redirect_to room_path(@room), notice: 'Resources States were successfully saved.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def set_resource_state
    @resource_state = ResourceState.find(params[:id])
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])

    unless @room
      redirect_to rooms_path, alert: 'Room doesnt exist.' and return
    end

    room_state = @room.room_state_for_today
    if room_state.nil?
      redirect_to room_path(@room), alert: 'Complete previous steps for Room.'
    elsif room_state.resource_states.any?
      redirect_to room_path(@room), alert: 'Already saved Common Attribute States for this Room today.'
    end

  end

  # Only allow a list of trusted parameters through.
  def resource_state_params
    params.require(:resource_states).values.map do |res_param|
      res_param.permit(:is_checked, :room_state_id, :resource_id)
    end
  end
end
