class SpecificAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create edit update_specific_attribute_states ]

  # GET /specific_attribute_states or /specific_attribute_states.json
  def index
    # currently not used
    @specific_attribute_states = SpecificAttributeState.all
    authorize @specific_attribute_states
  end

  # GET /specific_attribute_states/1 or /specific_attribute_states/1.json
  def show
  end

  # GET /specific_attribute_states/new
  def new
    fail
    @specific_attribute_states = @room.specific_attributes.all.map do |specific_attribute|
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
    # @room_state = @room.room_state_for_today
    @specific_attribute_states = specific_attribute_state_params.map do |sas_params|
      @room_state.specific_attribute_states.new(sas_params)
    end

    ActiveRecord::Base.transaction do
      @specific_attribute_states.each do |sas|
        raise ActiveRecord::Rollback unless sas.save
      end
    end

    if @specific_attribute_states.all?(&:persisted?)
      redirect_to new_resource_state_path(room_state_id: @room_state.id), notice: 'Specific Attribute States were successfully saved.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_specific_attribute_states
    authorize SpecificAttributeState

    specific_attribute_state_params.each do |cas_params|
      specific_attribute_state = SpecificAttributeState.find(cas_params[:specific_attribute_state_id])
      # raise ActiveRecord::Rollback unless specific_attribute_state.update(cas_params)
      unless specific_attribute_state.update(cas_params.except(:specific_attribute_state_id))
        render :edit, status: :unprocessable_entity
        return
      end
    end

    # if @specific_attribute_states.all?(&:persisted?)
      if @room_state.resource_states.any?
        redirect_to edit_resource_state_path(room_state_id: @room_state.id), notice: "Specific Attribute States were successfully updated."
      else
        redirect_to new_resource_state_path(room_state_id: @room_state.id), notice: 'Specific Attribute States were successfully saved.'
      end
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  # DELETE /specific_attribute_states/1 or /specific_attribute_states/1.json
  def destroy
    @specific_attribute_state.destroy!

    respond_to do |format|
      format.html { redirect_to specific_attribute_states_url, notice: "Specific attribute state was successfully destroyed." }
      format.json { head :no_content }
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
      # @room = Room.find_by(id: params[:room_id])
  
      # Redirects if certain conditions are not met
  
      unless @room
        redirect_to rooms_path, alert: 'Room doesnt exist.' and return
      end
  
      # room_state = @room.room_state_for_today
      # if room_state.nil?
      #   redirect_to room_path(@room), alert: 'Complete previous steps for Room.'
      # elsif room_state.specific_attribute_states.any?
      #   redirect_to room_path(@room), alert: 'Already saved Specific Attribute States for this Room today.'
      # end
    end
end
