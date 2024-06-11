class SpecificAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_specific_attribute_state, only: %i[ show edit update destroy ]

  # GET /specific_attribute_states or /specific_attribute_states.json
  def index
    @specific_attribute_states = SpecificAttributeState.all
    authorize @specific_attribute_states
  end

  # GET /specific_attribute_states/1 or /specific_attribute_states/1.json
  def show
  end

  # GET /specific_attribute_states/new
  def new
    @specific_attribute_state = SpecificAttributeState.new
  end

  # GET /specific_attribute_states/1/edit
  def edit
  end

  # POST /specific_attribute_states or /specific_attribute_states.json
  def create
    @specific_attribute_state = SpecificAttributeState.new(specific_attribute_state_params)

    respond_to do |format|
      if @specific_attribute_state.save
        format.html { redirect_to specific_attribute_state_url(@specific_attribute_state), notice: "Specific attribute state was successfully created." }
        format.json { render :show, status: :created, location: @specific_attribute_state }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specific_attribute_state.errors, status: :unprocessable_entity }
      end
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
      params.require(:specific_attribute_state).permit(:checkbox_value, :quantity_box_value, :room_state_id, :specific_attribute_id)
    end
end
