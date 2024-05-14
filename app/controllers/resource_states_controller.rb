class ResourceStatesController < ApplicationController
  before_action :set_resource_state, only: %i[ show edit update destroy ]

  # GET /resource_states or /resource_states.json
  def index
    @resource_states = ResourceState.all
  end

  # GET /resource_states/1 or /resource_states/1.json
  def show
  end

  # GET /resource_states/new
  def new
    @resource_state = ResourceState.new
  end

  # GET /resource_states/1/edit
  def edit
  end

  # POST /resource_states or /resource_states.json
  def create
    @resource_state = ResourceState.new(resource_state_params)

    respond_to do |format|
      if @resource_state.save
        format.html { redirect_to resource_state_url(@resource_state), notice: "Resource state was successfully created." }
        format.json { render :show, status: :created, location: @resource_state }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resource_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resource_states/1 or /resource_states/1.json
  def update
    respond_to do |format|
      if @resource_state.update(resource_state_params)
        format.html { redirect_to resource_state_url(@resource_state), notice: "Resource state was successfully updated." }
        format.json { render :show, status: :ok, location: @resource_state }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resource_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_states/1 or /resource_states/1.json
  def destroy
    @resource_state.destroy!

    respond_to do |format|
      format.html { redirect_to resource_states_url, notice: "Resource state was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_state
      @resource_state = ResourceState.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resource_state_params
      params.require(:resource_state).permit(:status, :is_checked, :room_state_id, :resource_id)
    end
end
