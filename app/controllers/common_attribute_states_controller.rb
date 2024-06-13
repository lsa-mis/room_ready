class CommonAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create ]

  # GET /common_attribute_states/new
  def new
    
    authorize CommonAttributeState

    @common_attribute_states = CommonAttribute.all.map do |common_attribute|
      common_attribute.common_attribute_states.new
    end
  end

  # POST /common_attribute_states or /common_attribute_states.json
  def create
    authorize CommonAttributeState

    @room_state = @room.room_state_for_today
    @common_attribute_states = common_attribute_state_params.map do |cas_params|
      @room_state.common_attribute_states.new(cas_params)
    end

    ActiveRecord::Base.transaction do
      @common_attribute_states.each do |cas|
        raise ActiveRecord::Rollback unless cas.save
      end
    end

    if @common_attribute_states.all?(&:persisted?)
      # redirect_to room_path(@room), notice: 'Common Attribute States were successfully saved.'
      redirect_to new_specific_attribute_state_path(room_id: @room), notice: 'Common Attribute States were successfully saved.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])

    # Redirects if certain conditions are not met

    unless @room
      redirect_to rooms_path, alert: 'Room doesnt exist.' and return
    end

    room_state = @room.room_state_for_today
    if room_state.nil?
      redirect_to room_path(@room), alert: 'Complete previous steps for Room.'
    elsif room_state.common_attribute_states.any?
      redirect_to room_path(@room), alert: 'Already saved Common Attribute States for this Room today.'
    end
  end

    # Only allow a list of trusted parameters through.
  def common_attribute_state_params
    params.require(:common_attribute_states).values.map do |cas_param|
      cas_param.permit(:checkbox_value, :quantity_box_value, :room_state_id, :common_attribute_id)
    end
  end
end
