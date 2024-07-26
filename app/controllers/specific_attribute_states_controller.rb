class SpecificAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create edit update_specific_attribute_states ]

  # GET /specific_attribute_states/1 or /specific_attribute_states/1.json
  def show
  end

  # GET /specific_attribute_states/new
  def new
    @specific_attribute_states = @room.active_specific_attributes.map do |specific_attribute|
      specific_attribute.specific_attribute_states.new
    end

    authorize SpecificAttributeState
  end

  # GET /specific_attribute_states/1/edit
  def edit
    @specific_attribute_states = @room_state.specific_attribute_states
    authorize @specific_attribute_states
  end

  # POST /specific_attribute_states or /specific_attribute_states.json
  def create
    authorize SpecificAttributeState
    @specific_attribute_states = specific_attribute_state_params.map do |sas_params|
      @room_state.specific_attribute_states.new(sas_params)
    end

    transaction = ActiveRecord::Base.transaction do
      @specific_attribute_states.each do |sas|
        raise ActiveRecord::Rollback unless sas.save
      end
      raise ActiveRecord::Rollback unless @room.update(last_time_checked: DateTime.now)
      true
    end

    if transaction
      redirect_to redirect_rover_to_correct_state(room: @room, room_state: @room_state, step: "specific_attributes", mode: "new")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_specific_attribute_states
    authorize SpecificAttributeState
    @specific_attribute_states = specific_attribute_state_params.map do |cas_params|
      params = cas_params.except(:specific_attribute_state_id)
      specific_attribute_state = SpecificAttributeState.find(cas_params[:specific_attribute_state_id])
      specific_attribute_state.assign_attributes(params)
      specific_attribute_state
    end
  
    transaction = ActiveRecord::Base.transaction do
      @specific_attribute_states.each do |cas|
        raise ActiveRecord::Rollback unless cas.save
      end
      raise ActiveRecord::Rollback unless @room.update(last_time_checked: DateTime.now)
      true
    end
  
    if transaction
      redirect_to redirect_rover_to_correct_state(room: @room, room_state: @room_state, step: "specific_attributes", mode: "edit")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    # Only allow a list of trusted parameters through.
    def specific_attribute_state_params
      params.require(:specific_attribute_states).values.map do |sas_param|
        sas_param.permit(:checkbox_value, :quantity_box_value, :room_state_id, :specific_attribute_id, :specific_attribute_state_id)
      end
    end

    def set_room
      @room_state = RoomState.find(params[:room_state_id])
      @room = @room_state.room
      @specific_form_announcement = Announcement.find_by(location: "specific_form")
      unless @room
        redirect_to rooms_path, alert: 'Room doesnt exist.' and return
      end
    end
end
