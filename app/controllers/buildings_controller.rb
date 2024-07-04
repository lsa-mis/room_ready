class BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ show edit update destroy archive unarchive unarchive_index] 
  # before_action :set_zone, only: %i[ new show create edit update index ]
  include BuildingApi

  def index
    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }
    @zones << ["No Zone", 0]
    if params[:show_archived] == "1" 
      @buildings = Building.archived
      @archived = true
    else
      @buildings = Building.active
      @archived = false
    end

    if params[:zone_id].present?
      zone_id = params[:zone_id]
      if zone_id == "0"
        @buildings = Building.active.where(zone_id: nil)
      else
        @buildings = Building.active.where(zone_id: zone_id)
      end
    end
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @buildings = @buildings.where('name ILIKE ? OR address ILIKE ? OR bldrecnbr ILIKE ? OR nick_name ILIKE ?', search_term, search_term, search_term, search_term)
    end

    @buildings = @buildings.order(:name)
    authorize @buildings
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
    floors_archived  = []
    floors_active  = []
    
    @building.floors.each do |floor|
      if floor.archived_rooms.present?
        floors_archived << floor
      end
      if floor.active_rooms.present?
        floors_active << floor
      end
    end
    
    if params["show_archived_rooms"] == "1"
      floors = floors_archived
      @archived = true
    else
      @archived = false
      floors = floors_active
    end

    authorize @building
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

  def destroy
    authorize @building
    if @building.has_checked_rooms?
      flash.now['alert'] = "The buildings has checked rooms - archive this building instead"
      @buildings = Building.active.order(:name)
    else
      if delete_building(@building)
        redirect_to buildings_path, notice: "The building was deleted."
      else
        @buildings = Building.active.order(:name)
      end
    end
  end

  def archive
    session[:return_to] = request.referer
    authorize @building
    if @building.zone.present?
      @building.update(zone_id: nil)
    end
    if @building.update(archived: true)
      @buildings = Building.active.order(:name)
      redirect_back_or_default(notice: "The building was archived")
    else
      @buildings = Building.active.order(:name)
    end
  end

  def unarchive
    session[:return_to] = request.referer
    authorize @building
    @archived = true
    if @building.update(archived: false)
      @buildings = Building.archived.order(:name)
      redirect_back_or_default(notice: "The building was unarchived")
    else
      @buildings = Building.archived.order(:name)
    end
  end

  def unarchive_index
    session[:return_to] = request.referer
    authorize @building
    @archived = true
    if @building.update(archived: false)
      @buildings = Building.archived.order(:name)
      @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }
      @zones << ["No Zone", 0]
      render :index, notice: "The building was unarchived"
    else
      @buildings = Building.archived.order(:name)
    end
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

    def add_from_bldrecnbr
      note = ""
      bldrecnbr = building_params[:bldrecnbr]
      @building = Building.new(bldrecnbr: bldrecnbr, zone_id: params[:zone_id])
      authorize @building
      result = get_building_info_by_bldrecnbr(bldrecnbr)
      if result['success']
        if result['data'].present?
          data = result['data'].first
          @building.name = data['BuildingLongDescription'].titleize
          address = "#{data['BuildingStreetNumber']}  #{data['BuildingStreetDirection']}  #{data['BuildingStreetName']}".strip.gsub(/\s+/, " ")
          @building.address = address.titleize
          @building.city = data['BuildingCity'].titleize
          @building.state = data['BuildingState']
          @building.zip = data['BuildingPostal']
    
          respond_to do |format|
            if @building.save
              add_classrooms_for_building(bldrecnbr)
              notice = "New Building was added." + note
              @buildings = Building.active.where(zone: @zone)
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

    def delete_building(building)
      begin
        Resource.where(room_id: building.rooms.ids).delete_all
        SpecificAttribute.where(room_id: building.rooms.ids).delete_all
        Room.where(floor_id: building.floors.ids).delete_all
        Floor.where(building_id: building).delete_all
        if building.delete 
          return true
        else
          return false
        end
      rescue StandardError => e
        raise ActiveRecord::Rollback
        return false
      end
    end
end
