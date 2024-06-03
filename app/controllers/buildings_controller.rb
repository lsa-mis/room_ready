class BuildingsController < ApplicationController
  before_action :auth_user
  before_action :set_building, only: %i[ show edit update destroy ]

  # GET /buildings or /buildings.json
  def index
    @buildings = Building.where(zone: nil)
    authorize @buildings
  end

  # GET /buildings/1 or /buildings/1.json
  def show
  end

  # GET /buildings/new
  def new
    @building = Building.new()
    @zones = Zone.all.map { |z| [z.name, z.id] }
    authorize @building
  end

  # GET /buildings/1/edit
  def edit
    @zones = Zone.all.pluck(:name, :id)
  end

  # POST /buildings or /buildings.json
  def create
    @building = Building.new(building_params)

    respond_to do |format|
      if @building.save
        format.html { redirect_to building_url(@building), notice: "building was successfully created." }
        format.json { render :show, status: :created, location: @building }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    @zone = Zone.find(params[:zone_id])
    respond_to do |format|
      if @building.update(building_params)
        fail
        format.html { redirect_to zone_buildings_path(@zone,@building), notice: "building was successfully updated." }
        format.json { render :show, status: :ok, location: @building }
      else
        fail
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1 or /buildings/1.json
  def destroy
    @building.destroy!

    respond_to do |format|
      format.html { redirect_to buildings_url, notice: "building was successfully destroyed." }
      format.json { head :no_content }
    end
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
      authorize @building
    end

end
