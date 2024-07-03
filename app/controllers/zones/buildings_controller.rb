class Zones::BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ remove_building ]
  before_action :set_zone
  include BuildingApi

  def index
    @building = Building.new
    @buildings = Building.active.where(zone: @zone).order(:name)
    authorize @buildings
  end

  def create
    if params[:building_id].present?
      return add_building_from_existing
    end
  end

  # DELETE /buildings/1 or /buildings/1.json
  def remove_building
    authorize([@zone, @building])
    if @zone.buildings.delete(@building)
      @buildings = Building.active.where(zone: @zone).order(:name)
      flash.now[:notice] = "The building was removed from the zone."
    end
    @building = Building.new
  end

  private
    # Only allow a list of trusted parameters through.
    def building_params
      params.require(:building).permit(:bldrecnbr, :name, :nick_name, :address, :city, :state, :zip, :zone_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
    end

    def set_zone
      @zone_id = params[:zone_id]
      @zone = Zone.find(params[:zone_id])
    end

    def add_building_from_existing
      @building = Building.find(params[:building_id])
      authorize([@zone, @building]) 
      if @zone.buildings << @building
        @building = Building.new
        @buildings = Building.active.where(zone: @zone).order(:name)
        flash.now[:notice] = "The building was added."
      end
    end

end
