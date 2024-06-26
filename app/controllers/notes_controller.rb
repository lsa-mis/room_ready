class NotesController < ApplicationController
  # before_action :auth_user
  # before_action :set_room
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = Note.all
    authorize @notes
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    fail
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    # @note.room = @room
    @note.user = current_user
    authorize @note
    if @note.save
      @notes = Note.where(room: @room).order("updated_at DESC")
      @new_note = Note.new(room: @room)
      flash.now[:notice] = "note successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    if @note.update(note_params)
      @notes = Note.where(room: @note.room).order("updated_at DESC")
      flash.now[:notice] = "note successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!
    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # def set_room
    #   fail
    #   @room = Room.find(params[:room_id])
    # end 

    def set_note
      @note = Note.find(params[:id])
      authorize @note
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:content, :room_id)
    end
end
