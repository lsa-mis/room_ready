class AnnouncementsController < ApplicationController
  before_action :auth_user
  before_action :set_announcement, only: %i[ show edit update ]

  # GET /announcements or /announcements.json
  def index
    @announcements = Announcement.all.with_rich_text_content.order(:id)
    authorize @announcements
  end

  # GET /announcements/1 or /announcements/1.json
  def show
  end

  # GET /announcements/1/edit
  def edit
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcements_url, notice: "Announcement was successfully updated." }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
      authorize @announcement
    end

    # Only allow a list of trusted parameters through.
    def announcement_params
      params.require(:announcement).permit(:location, :content)
    end
end
