class CommonAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create edit update_common_attribute_states ]

  # GET /common_attribute_states/new
  def new
    
    authorize CommonAttributeState

    @common_attribute_states = CommonAttribute.active.map do |common_attribute|
      common_attribute.common_attribute_states.new
    end
  end

  def edit
    @common_attribute_states = @room_state.common_attribute_states
    authorize @common_attribute_states
  end

  # POST /common_attribute_states or /common_attribute_states.json
  def create
    authorize CommonAttributeState
    @common_attribute_states = common_attribute_state_params.map do |cas_params|
      @room_state.common_attribute_states.new(cas_params)
    end

    transaction = ActiveRecord::Base.transaction do
      @common_attribute_states.each do |cas|
        raise ActiveRecord::Rollback unless cas.save
      end
      raise ActiveRecord::Rollback unless @room.update(last_time_checked: DateTime.now)
      true
    end

    if transaction
      redirect_to redirect_rover_to_correct_state(room: @room, room_state: @room_state, step: "common_attributes", mode: "new")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_common_attribute_states
    authorize CommonAttributeState
    @common_attribute_states = common_attribute_state_params.map do |cas_params|
      params = cas_params.except(:common_attribute_state_id)
      common_attribute_state = CommonAttributeState.find(cas_params[:common_attribute_state_id])
      common_attribute_state.assign_attributes(params)
      common_attribute_state
    end
  
    transaction = ActiveRecord::Base.transaction do
      @common_attribute_states.each do |cas|
        raise ActiveRecord::Rollback unless cas.save
      end
      raise ActiveRecord::Rollback unless @room.update(last_time_checked: DateTime.now)
      true
    end
  
    if transaction
      redirect_to redirect_rover_to_correct_state(room: @room, room_state: @room_state, step: "common_attributes", mode: "edit")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room_state = RoomState.find(params[:room_state_id])
    @room = @room_state.room
    # Redirects if certain conditions are not met
    @common_form_announcement = Announcement.find_by(location: "common_form")
    unless @room
      redirect_to rooms_path, alert: 'Room doesnt exist.' and return
    end

  end

    # Only allow a list of trusted parameters through.
  def common_attribute_state_params
    params.require(:common_attribute_states).values.map do |cas_param|
      cas_param.permit(:checkbox_value, :quantity_box_value, :room_state_id, :common_attribute_id, :common_attribute_state_id)
    end
  end
end
