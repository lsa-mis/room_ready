class Rooms::SpecificAttributesController < ApplicationController
  before_action :auth_user
  before_action :set_room
  before_action :set_specific_attribute, only: %i[edit update destroy archive unarchive ]

  # GET /specific_attributes or /specific_attributes.json
  def index
    if params["show_archived"] == "1"
      @specific_attributes = SpecificAttribute.archived.where(room_id: @room)
      @action_title = "Unarchive"
    else
      @specific_attributes = SpecificAttribute.active.where(room_id: @room)
      @action_title = "Delete/Archive"
    end
    @archived = SpecificAttribute.archived.where(room_id: @room).present? ? true : false
  
    @new_specific_attribute = SpecificAttribute.new
    authorize @specific_attributes
  end

  # GET /specific_attributes/new
  def new
    @specific_attribute = SpecificAttribute.new
    authorize @specific_attribute
  end

  # GET /specific_attributes/1/edit
  def edit
  end

  # POST /specific_attributes or /specific_attributes.json
  def create
    @specific_attribute = @room.specific_attributes.new(specific_attribute_params)
    authorize @specific_attribute

    respond_to do |format|
      if @specific_attribute.save
        notice = "Specific attribute was successfully created."
        format.turbo_stream do
          @new_specific_attribute = SpecificAttribute.new
          flash.now[:notice] = notice
        end
        format.html { redirect_to room_specific_attributes_path(@room), notice: notice }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specific_attributes/1 or /specific_attributes/1.json
  def update
    respond_to do |format|
      if @specific_attribute.update(specific_attribute_params)
        format.html { redirect_to room_specific_attributes_path(@room), notice: "Specific attribute was successfully updated." }
        format.json { render :show, status: :ok, location: @specific_attribute }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specific_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specific_attributes/1 or /specific_attributes/1.json
  def archive
    if @specific_attribute.update(archived: true)
      @room = Room.find(params[:room_id])
      @specific_attributes = SpecificAttribute.active.where(room_id: @room)
      @new_specific_attribute = SpecificAttribute.new
      @archived = true
      @action_title = "Delete/Archive"
      flash.now["notice"] = "The specific attribute was archived."
    else
      render :index, status: :unprocessable_entity 
    end
  end

  def unarchive
    if @specific_attribute.update(archived: false)
      @room = Room.find(params[:room_id])
      @specific_attributes = SpecificAttribute.archived.where(room_id: @room)
      @action_title = "Unarchive"
      flash.now["notice"] = "The specific attribute was unarchived."
    else
      render :index, status: :unprocessable_entity 
    end
  end

  def destroy
    @specific_attribute.destroy!
    @room = Room.find(params[:room_id])
    @specific_attributes = SpecificAttribute.active.where(room_id: @room)
    flash.now["notice"] = "Specific attribute was deleted."
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end
    # Use callbacks to share specific setup or constraints between actions.
  def set_specific_attribute
    @specific_attribute = SpecificAttribute.find(params[:id])
    authorize @specific_attribute
  end

  # Only allow a list of trusted parameters through.
  def specific_attribute_params
    params.require(:specific_attribute).permit(:description, :need_checkbox, :need_quantity_box, :room_id)
  end
end
