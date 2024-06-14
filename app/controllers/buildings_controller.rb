class BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ show edit update ]
  before_action :set_zone, only: %i[ new show create edit update ]
  include BuildingApi

  def index
    if params[:zone_id].present?
      if params[:zone_id] == "0"
        @buildings = Building.where(zone_id: nil).order(:name)
      else
        @buildings = Building.where(zone_id: params[:zone_id]).order(:name)
      end
    else
      @buildings = Building.all.order(:zone_id, :name)
    end
    authorize @buildings
    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }
    @zones << ["No Zone", 0]
  end

  def new
    @building = Building.new
    @zones = Zone.all
    authorize @building
  end

  def create
    if building_params[:bldrecnbr].present?
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
    authorize @building
  end
    
  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    authorize @building
    if @building.update(building_params)
      if @zone.present?
        redirect_to zone_buildings_path(@zone), notice: notice
      else 
        redirect_to buildings_path, notice: notice
      end
    else 
      render :edit, status: :unprocessable_entity
    end
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
      if params[:zone_id].present?
        @zone = Zone.find(params[:zone_id])
      end
    end

    def add_from_bldrecnbr
      note = ""
      bldrecnbr = building_params[:bldrecnbr]
      @building = Building.new(bldrecnbr: bldrecnbr, zone_id: params[:zone_id])
      authorize @building
      result = get_building_info_by_bldrecnbr(bldrecnbr)
      if result['success']
        if result['data'].present?
          data = result['data'].first
          @building.name = data['BuildingLongDescription']
          @building.address = "#{data['BuildingStreetNumber']}  #{data['BuildingStreetDirection']}  #{data['BuildingStreetName']}".strip.gsub(/\s+/, " ")
          @building.city = data['BuildingCity']
          @building.state = data['BuildingState']
          @building.zip = data['BuildingPostal']
    
          respond_to do |format|
            if @building.save
              note = add_classrooms_for_building(bldrecnbr)
              notice = "New Building was added." + note
              @buildings = Building.where(zone: @zone)
              format.turbo_stream do
                @new_building = Building.new
                if @zone.present?
                redirect_to zone_buildings_path(@zone), notice: notice
                else 
                  redirect_to buildings_path, notice: notice
                end
              end
            else
              format.html { render :new, status: :unprocessable_entity }
            end
          end
        end
      else
        flash.now[:alert] = result['errorcode'] + result['error']
        render :new, status: :unprocessable_entity
      end
    end

    def add_classrooms_for_building(bldrecnbr)
      result = get_classrooms_for_building(bldrecnbr)
      note = ''
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
        note = " API returned no data about classrooms for the building"
      end
      return note
    end
end
