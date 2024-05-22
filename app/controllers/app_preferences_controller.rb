class AppPreferencesController < ApplicationController
  before_action :auth_user
  before_action :set_app_preference, only: %i[ show edit update destroy ]

  # GET /app_preferences or /app_preferences.json
  def index
    @app_preferences = AppPreference.all
    @preference_page_announcement = Announcement.find_by(location: "preference_page")
    authorize @app_preferences
  end

  # GET /app_preferences/1 or /app_preferences/1.json
  def show
  end

  # GET /app_preferences/new
  def new
    @app_preference = AppPreference.new
    authorize @app_preference
    @pref_types = AppPreference.pref_types.keys.map{ |key| [key.titleize, key] }
  end

  # GET /app_preferences/1/edit
  def edit
    @pref_types = AppPreference.pref_types.keys.map{ |key| [key.titleize, key] }
  end

  # POST /app_preferences or /app_preferences.json
  def create
    @app_preference = AppPreference.new(app_preference_params)
    authorize @app_preference
    respond_to do |format|
      if @app_preference.save
        format.html { redirect_to app_preferences_url, notice: "App preference was successfully created." }

      else
        format.html { render :new, status: :unprocessable_entity }
        @pref_types = AppPreference.pref_types.keys.map{ |key| [key.titleize, key] }
      end
    end
  end

  # PATCH/PUT /app_preferences/1 or /app_preferences/1.json
  def update
    respond_to do |format|
      if @app_preference.update(app_preference_params)
        format.html { redirect_to app_preferences_url, notice: "App preference was successfully updated." }
        format.json { render :show, status: :ok, location: @app_preference }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_preferences/1 or /app_preferences/1.json
  def destroy
    @app_preference.destroy!

    respond_to do |format|
      format.html { redirect_to app_preferences_url, notice: "App preference was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_preference
      @app_preference = AppPreference.find(params[:id])
      authorize @app_preference
    end

    # Only allow a list of trusted parameters through.
    def app_preference_params
      params.require(:app_preference).permit(:name, :description, :pref_type, :value)
    end
end
