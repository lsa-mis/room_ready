class ZonesController < ApplicationController
  before_action :auth_user
  before_action :set_zone, only: %i[ show edit update destroy ]

  # GET /zones or /zones.json
  def index
    @zones = Zone.all.order(:name)
    authorize @zones
  end

  # GET /zones/1 or /zones/1.json
  def show
  end

  # GET /zones/new
  def new
    @zone = Zone.new
    authorize @zone
  end

  # GET /zones/{id}/edit
  def edit
  end

  # POST /zones or /zones.json
  def create
    @zone = Zone.new(zone_params)
    authorize @zone
    respond_to do |format|
      if @zone.save
        format.html { redirect_to zones_path, notice: "Zone was successfully created." }
        format.json { render :show, status: :created, location: @zone }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /zones/1 or /zones/1.json
  def update
    respond_to do |format|
      if @zone.update(zone_params)
        format.html { redirect_to zones_path, notice: "Zone was successfully updated." }
        format.json { render :show, status: :ok, location: @zone }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zones/1 or /zones/1.json
  def destroy
    @zone.buildings.delete_all
    @zone.destroy!

    respond_to do |format|
      format.html { redirect_to zones_url, notice: "Zone was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zone
      @zone = Zone.find(params[:id])
      authorize @zone
    end

    # Only allow a list of trusted parameters through.
    def zone_params
      params.require(:zone).permit(:name)
    end
end
