class SpecificAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_specific_attribute_state, only: %i[ show edit update destroy ]
  before_action :set_room, only: %i[ new create ]

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
    @specific_attribute_states = @room.specific_attributes.all.map do |specific_attribute|
      specific_attribute.specific_attribute_states.new
    end

    authorize SpecificAttributeState
  end

  # GET /specific_attribute_states/1/edit
  def edit
  end

  # POST /specific_attribute_states or /specific_attribute_states.json
  def create
    authorize SpecificAttributeState

    @room_state = @room.room_state_for_today
    @specific_attribute_states = specific_attribute_state_params.map do |sas_params|
      @room_state.specific_attribute_states.new(sas_params)
    end

    ActiveRecord::Base.transaction do
      @specific_attribute_states.each do |sas|
        raise ActiveRecord::Rollback unless sas.save
      end
    end

    if @specific_attribute_states.all?(&:persisted?)
      redirect_to room_path(@room), notice: 'Specific Attribute States were successfully saved.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /specific_attribute_states/1 or /specific_attribute_states/1.json
  def update
    respond_to do |format|
      if @specific_attribute_state.update(specific_attribute_state_params)
        format.html { redirect_to specific_attribute_state_url(@specific_attribute_state), notice: "Specific attribute state was successfully updated." }
        format.json { render :show, status: :ok, location: @specific_attribute_state }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specific_attribute_state.errors, status: :unprocessable_entity }
      end
    end
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
    def set_specific_attribute_state
      @specific_attribute_state = SpecificAttributeState.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def specific_attribute_state_params
      params.require(:specific_attribute_states).values.map do |sas_param|
        sas_param.permit(:checkbox_value, :quantity_box_value, :room_state_id, :specific_attribute_id)
      end
    end

    def set_room
      @room = Room.find_by(id: params[:room_id])
  
      # Redirects if certain conditions are not met
  
      unless @room
        redirect_to rooms_path, alert: 'Room doesnt exist.' and return
      end
  
      room_state = @room.room_state_for_today
      if room_state.nil?
        redirect_to room_path(@room), alert: 'Complete previous steps for Room.'
      elsif room_state.specific_attribute_states.any?
        redirect_to room_path(@room), alert: 'Already saved Specific Attribute States for this Room today.'
      end
    end
end
