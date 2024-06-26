class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

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
    @note.user = current_user
    authorize @note
    if @note.save
      @notes = Note.where(room: @room).order("updated_at DESC")
      @new_note = Note.new(room: @room)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    if @note.update(note_params) && @note.update(user_id: current_user.id)
      @notes = Note.where(room: @note.room).order("updated_at DESC")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    if @note.destroy
      @notes = Note.where(room: @note.room).order("updated_at DESC")
    end
    
  end

  private

    def set_note
      @note = Note.find(params[:id])
      authorize @note
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:content, :room_id)
    end
end
