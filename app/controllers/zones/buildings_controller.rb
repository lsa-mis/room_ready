class Zones::BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ edit update remove_building show ]
  before_action :set_zone
  include BuildingApi

  def index
    @building = Building.new
    @buildings = Building.where(zone: @zone)
    authorize @buildings
  end

  def new
    @building = Building.new
    @zones = Zone.all.map { |z| [z.name, z.id] }
    authorize @building
  end

  def create
    if params[:building_id].present?
      return add_building_from_existing
    elsif building_params[:bldrecnbr].present?
      return add_from_bldrecnbr
    end
  end

  def show
    authorize @building
    floors = @building.floors
    floor_names_sorted = sort_floors(floors.pluck(:name).uniq)
    @floors = floors.in_order_of(:name, floor_names_sorted)
  end

  def edit
    @zones = Zone.all.map { |z| [z.name, z.id] }
    authorize([@zone, @building])
  end
    
  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    authorize([@zone, @building])
    if @building.update(building_params)
      redirect_to zone_buildings_path, notice: "Building was successfully updated."
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /buildings/1 or /buildings/1.json
  def remove_building
    authorize([@zone, @building])
    if @zone.buildings.delete(@building)
      @buildings = Building.where(zone: @zone)
      flash.now[:notice] = "The building was removed from the zone."
    end
    @building = Building.new
  end

  private
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

    def add_building_from_existing
      @building = Building.find(params[:building_id])
      authorize([@zone, @building]) 
      if @zone.buildings << @building
        @building = Building.new
        @buildings = Building.where(zone: @zone)
        flash.now[:notice] = "The building was added."
      end
    end

    def add_from_bldrecnbr
      note = ""
      bldrecnbr = building_params[:bldrecnbr]
      @building = Building.new(bldrecnbr: bldrecnbr, zone_id: params[:zone_id])
      building_data = get_building_info_by_bldrecnbr(bldrecnbr)
      if building_data['data'].present?
        data = building_data['data'].first
        @building.name = data['BuildingLongDescription']
        @building.address = "#{data['BuildingStreetNumber']}  #{data['BuildingStreetDirection']}  #{data['BuildingStreetName']}".strip.gsub(/\s+/, " ")
        @building.city = data['BuildingCity']
        @building.state = data['BuildingState']
        @building.zip = data['BuildingPostal']
      else 
        note = " API returned no data about #{bldrecnbr} building"
      end

      authorize([@zone, @building])
      respond_to do |format|
        if @building.save
          add_classrooms_for_building(bldrecnbr)
          notice = "New Building was added to the zone." + note
          @buildings = Building.where(zone: @zone)
          format.turbo_stream do
            @new_building = Building.new
            redirect_to zone_buildings_path, notice: notice
          end
          format.html { redirect_to zone_buildings_path, notice: notice }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def add_classrooms_for_building(bldrecnbr)
      result = get_classromms_for_building(bldrecnbr)
      if result['data'].present?
        rooms_data = result['data']
        rooms_data.each do |row|
          if row['RoomTypeDescription'] == "Classroom"
            if Floor.find_by(name: row["FloorNumber"], building: @building).present?
              floor = Floor.find_by(name: row["FloorNumber"], building: @building)
            else
             floor = Floor.new(name: row["FloorNumber"], building: @building)
             floor.save
            end
            room = Room.new(rmrecnbr: row["RoomRecordNumber"], room_number: row["RoomNumber"], room_type: "Classroom", floor: floor)
            room.save
          end
        end
      else
        note = " API returned bo data about classrooms for the building"
      end
    end
end
