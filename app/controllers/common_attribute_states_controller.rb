class CommonAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ new create ]
  before_action :set_common_attribute_state, only: %i[ show edit update destroy ]

  # GET /common_attribute_states or /common_attribute_states.json
  def index
    @common_attribute_states = CommonAttributeState.all
    authorize @common_attribute_states
  end

  # GET /common_attribute_states/1 or /common_attribute_states/1.json
  def show
  end

  # GET /common_attribute_states/new
  def new
    authorize CommonAttributeState.new

    @common_attribute_states = CommonAttribute.all.map do |common_attribute|
      common_attribute.common_attribute_states.new
    end
  end

  # GET /common_attribute_states/1/edit
  def edit
  end

  # POST /common_attribute_states or /common_attribute_states.json
  def create
    authorize CommonAttributeState.new

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
      redirect_to common_attribute_states_path, notice: 'Common Attribute States were successfully saved.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /common_attribute_states/1 or /common_attribute_states/1.json
  def update
    respond_to do |format|
      if @common_attribute_state.update(common_attribute_state_params)
        format.html { redirect_to common_attribute_state_url(@common_attribute_state), notice: "Common attribute state was successfully updated." }
        format.json { render :show, status: :ok, location: @common_attribute_state }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @common_attribute_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /common_attribute_states/1 or /common_attribute_states/1.json
  def destroy
    @common_attribute_state.destroy!

    respond_to do |format|
      format.html { redirect_to common_attribute_states_url, notice: "Common attribute state was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_common_attribute_state
    @common_attribute_state = CommonAttributeState.find(params[:id])
    authorize @common_attribute_state
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])

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
