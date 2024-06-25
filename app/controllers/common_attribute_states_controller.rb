class CommonAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create edit update_common_attribute_states ]

  # GET /common_attribute_states/new
  def new
    
    authorize CommonAttributeState

    @common_attribute_states = CommonAttribute.all.map do |common_attribute|
      common_attribute.common_attribute_states.new
    end

    unless @common_attribute_states.present?
      redirect_to new_specific_attribute_state_path(room_state_id: @room_state.id)
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

    ActiveRecord::Base.transaction do
      @common_attribute_states.each do |cas|
        raise ActiveRecord::Rollback unless cas.save
      end
      unless @room.update(last_time_checked: DateTime.now)
        flash.now['alert'] = "Error updating room record"
        return
      end
    end

    if @common_attribute_states.all?(&:persisted?)
      # redirect_to room_path(@room), notice: 'Common Attribute States were successfully saved.'
      redirect_to new_specific_attribute_state_path(room_state_id: @room_state.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_common_attribute_states
    authorize CommonAttributeState
    common_attribute_state_params.each do |cas_params|
      common_attribute_state = CommonAttributeState.find(cas_params[:common_attribute_state_id])
      # raise ActiveRecord::Rollback unless common_attribute_state.update(cas_params)
      unless common_attribute_state.update(cas_params.except(:common_attribute_state_id))
        render :edit, status: :unprocessable_entity
        return
      end
    end

    unless @room.update(last_time_checked: DateTime.now)
      flash.now['alert'] = "Error updating room record"
      return
    end

    # if @common_attribute_states.all?(&:persisted?)
      if @room_state.specific_attribute_states.any?
        redirect_to edit_specific_attribute_state_path(room_state_id: @room_state.id)
      else
        redirect_to new_specific_attribute_state_path(room_state_id: @room_state.id)
      end
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  private

  def set_room
    @room_state = RoomState.find(params[:room_state_id])
    @room = @room_state.room
    # Redirects if certain conditions are not met
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
