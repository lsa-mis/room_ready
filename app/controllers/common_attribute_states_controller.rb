class CommonAttributeStatesController < ApplicationController
  before_action :auth_user
  before_action :set_common_attribute_state, only: %i[ show edit update destroy ]

  # GET /common_attribute_states or /common_attribute_states.json
  def index
    @common_attribute_states = CommonAttributeState.all
  end

  # GET /common_attribute_states/1 or /common_attribute_states/1.json
  def show
  end

  # GET /common_attribute_states/new
  def new
    @common_attribute_state = CommonAttributeState.new
  end

  # GET /common_attribute_states/1/edit
  def edit
  end

  # POST /common_attribute_states or /common_attribute_states.json
  def create
    @common_attribute_state = CommonAttributeState.new(common_attribute_state_params)

    respond_to do |format|
      if @common_attribute_state.save
        format.html { redirect_to common_attribute_state_url(@common_attribute_state), notice: "Common attribute state was successfully created." }
        format.json { render :show, status: :created, location: @common_attribute_state }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @common_attribute_state.errors, status: :unprocessable_entity }
      end
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
    end

    # Only allow a list of trusted parameters through.
    def common_attribute_state_params
      params.require(:common_attribute_state).permit(:checkbox_value, :quantity_box_value, :room_state_id, :common_attribute_id)
    end
end
