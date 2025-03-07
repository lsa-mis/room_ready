class BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ show edit update destroy archive unarchive unarchive_index] 
  before_action :set_zone
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

    @buildings = @buildings
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
    # to show/hide 'Show Archived Rooms' checkbox and show active or archived rooms on floors on Buiding show page
    @archived = params["show_archived_rooms"] == "1" ? true : false 
    floors = @building.floors
    floor_names_sorted = sort_floors(floors.pluck(:name).uniq)
    @floors = floors.in_order_of(:name, floor_names_sorted)
  end

  def edit
    @zones = Zone.all.map { |z| [z.name, z.id] }
  end
    
  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    if @building.update(building_params)
        redirect_to building_path(@building), notice: notice
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @building.has_checked_rooms?
      flash.now['alert'] = "The buildings has checked rooms - archive this building instead"
      @buildings = Building.active
    else
      if delete_building(@building)
        redirect_to buildings_path, notice: "The building was deleted."
      else
        @buildings = Building.active
        flash.now["alert"] = "Error deleting building."
      end
    end
  end

  def archive
    session[:return_to] = request.referer
    if @building.zone.present?
      @building.update(zone_id: nil)
    end
    if change_building_archived_mode(building: @building, archived: true)
      @buildings = Building.active
      redirect_back_or_default(notice: "The building was archived")
    else
      @buildings = Building.active
    end
  end

  def unarchive
    session[:return_to] = request.referer
    @archived = true
    if change_building_archived_mode(building: @building, archived: false)
      @buildings = Building.archived
      redirect_back_or_default(notice: "The building was unarchived")
    else
      @buildings = Building.archived
    end
  end

  def unarchive_index
    session[:return_to] = request.referer
    authorize @building
    @archived = true
    if change_building_archived_mode(building: @building, archived: false)
      @buildings = Building.archived
      @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }
      @zones << ["No Zone", 0]
      render :index, notice: "The building was unarchived"
    else
      @buildings = Building.archived
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
      authorize @building
    end

    def set_zone
      # params[:zone_id] == 0 for "No Zones" option
      if params[:zone_id].present? && params[:zone_id] != "0"
        @zone_id = params[:zone_id]
        @zone = Zone.find(params[:zone_id])
      end
    end

    def add_from_bldrecnbr
      note = ""
      bldrecnbr = building_params[:bldrecnbr]
      @building = Building.new
      authorize @building
      result = get_building_info_by_bldrecnbr(bldrecnbr)
      if result['success']
        if result['data'].present?
          if result['data'].count > 1
            flash.now[:alert] = "The API returned multiple buildings for the #{bldrecnbr} number. Please change it."
            render :new, status: :unprocessable_entity
          else
            data = result['data'].first
            @building.zone_id = params[:zone_id]
            @building.bldrecnbr = data['BuildingRecordNumber']
            @building.name = data['BuildingLongDescription'].titleize
            address = "#{data['BuildingStreetNumber']}  #{data['BuildingStreetDirection']}  #{data['BuildingStreetName']}".strip.gsub(/\s+/, " ")
            @building.address = address.titleize
            @building.city = data['BuildingCity'].titleize
            @building.state = data['BuildingState']
            @building.zip = data['BuildingPostal']
            authorize @building
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

    def change_building_archived_mode(building:, archived:)
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless building.update(archived: archived)
        raise ActiveRecord::Rollback unless Room.where(floor_id: building.floors.ids).update_all(archived: archived)
        rooms = archived ? Room.archived.where(floor_id: building.floors.ids) : Room.active.where(floor_id: building.floors.ids)
        rooms.each do |room|
          raise ActiveRecord::Rollback unless room.specific_attributes.update(archived: archived)
          raise ActiveRecord::Rollback unless room.resources.update(archived: archived)
        end
      end
      true
    end

    def delete_building(building)
      begin
        rooms_ids = building.rooms.ids
        Resource.where(room_id: rooms_ids).delete_all
        SpecificAttribute.where(room_id: rooms_ids).delete_all
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
