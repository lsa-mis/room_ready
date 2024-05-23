class BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ show edit update destroy ]

  # GET /buildings or /buildings.json
  def index
    @zone_id = zone_id_params
    @buildings = Building.where(zone_id: @zone_id)
    @zone_name = Zone.find(@zone_id).name
    authorize @buildings
  end

  # GET /buildings/1 or /buildings/1.json
  def show
    building = Building.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: building }
    end
  end

  # GET /buildings/new
  def new
    @zone_id = zone_id_params
    @building = Building.new()
    authorize @building
  end

  # GET /buildings/1/edit
  def edit
    @zone_id = zone_id_params
  end

  # POST /buildings or /buildings.json
  def create
    @building_params = building_params
    @zone_id = @building_params[:zone_id]
  
    # Check if a building with the bldrecnbr already exists
    @building = Building.find_by(bldrecnbr: @building_params[:bldrecnbr])
  
    if @building
      # If the building exists, update the existing building's attributes
      authorize @building
      respond_to do |format|
        if @building.update(@building_params)
          format.html { redirect_to zone_building_path(@zone_id, @building), notice: "Building was successfully added." }
          format.json { render :show, status: :ok, location: @building }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @building.errors, status: :unprocessable_entity }
        end
      end
    else
      # If the building does not exist, create a new one
      @building = Building.new(@building_params)
      authorize @building
      respond_to do |format|
        if @building.save
          format.html { redirect_to zone_building_path(@zone_id, @building), notice: "Building was successfully added." }
          format.json { render :show, status: :ok, location: @building }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @building.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    @building_params = building_params
    @zone_id = @building_params[:zone_id]
    respond_to do |format|
      if @building.update(building_params)
        format.html { redirect_to zone_building_path(@zone_id, @building), notice: "Building was successfully updated." }
        format.json { render :show, status: :ok, location: @building }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1 or /buildings/1.json
  def destroy
    @zone_id = @building[:zone_id]
    @zone = Zone.find(@zone_id)

    respond_to do |format|
      if @zone.buildings.delete(@building)
        format.html { redirect_to zone_buildings_path(@zone_id), notice: "Building was successfully removed." }
        format.json { render :show, status: :ok, location: @building }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
      authorize @building
    end

    # Only allow a list of trusted parameters through.
    def building_params
      params.require(:building).permit(:bldrecnbr, :name, :nick_name, :abbreviation, :address, :city, :state, :zip, :zone_id)
    end

    def zone_id_params
      params.require(:zone_id)
    end
end
