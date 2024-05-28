class Zones::BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ remove_building ]
  before_action :set_zone


  def index
    @building = Building.new
    @buildings = Building.where(zone: @zone)
    @idle_buildings = Building.where(zone: nil)
    authorize @buildings
  end

  def new
    @zone_name = Zone.find(@zone_id).name
    @building = Building.new
    @zones = Zone.all.map { |z| [z.name, z.id] }
    authorize @building
  end

  def create
    @building = Building.new(bldrecnbr: building_params[:bldrecnbr], zone_id: params[:zone_id])
    authorize([@zone, @building]) 
    if @building.save
      format.html { redirect_to zone_buildings_path, notice: "Building was added" }
      format.json { render :show, status: :ok, location: @building }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @building.errors, status: status }
    end
    # if @zone.buildings << @building
    #   fail
    #   @building = Building.new
    #   @buildings = Building.where(zone: @zone)
    #   flash.now[:notice] = "The building was added."
    # else
    #   fail
    # end
    
  end

  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    @building_params = building_params
    @zone_id = @building_params[:zone_id]

    success = @building.update(building_params)
    respond_with_notice(success, zone_building_path(@zone_id, @building), "Building was successfully updated")
  end

  # DELETE /buildings/1 or /buildings/1.json
  def remove_building
    authorize([@zone, @building])
    if @zone.buildings.delete(@building)
      @buildings = Building.where(zone: @zone)
      flash.now[:notice] = "The building was removed from the program."
    end
    @building = Building.new
  end

  private
    def respond_with_notice(success, redirect, notice_text)
      respond_to do |format|
        if success
          format.html { redirect_to redirect, notice: notice_text }
          format.json { render :show, status: :ok, location: @building }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @building.errors, status: status }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def building_params
      params.require(:building).permit(:bldrecnbr, :name, :nick_name, :abbreviation, :address, :city, :state, :zip, :zone_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
    end

    def set_zone
      @zone_id = params[:zone_id]
      @zone = Zone.find(params[:zone_id])
    end
end
