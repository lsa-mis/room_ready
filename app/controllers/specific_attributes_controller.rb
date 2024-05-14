class SpecificAttributesController < ApplicationController
  before_action :set_specific_attribute, only: %i[ show edit update destroy ]

  # GET /specific_attributes or /specific_attributes.json
  def index
    @specific_attributes = SpecificAttribute.all
  end

  # GET /specific_attributes/1 or /specific_attributes/1.json
  def show
  end

  # GET /specific_attributes/new
  def new
    @specific_attribute = SpecificAttribute.new
  end

  # GET /specific_attributes/1/edit
  def edit
  end

  # POST /specific_attributes or /specific_attributes.json
  def create
    @specific_attribute = SpecificAttribute.new(specific_attribute_params)

    respond_to do |format|
      if @specific_attribute.save
        format.html { redirect_to specific_attribute_url(@specific_attribute), notice: "Specific attribute was successfully created." }
        format.json { render :show, status: :created, location: @specific_attribute }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specific_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specific_attributes/1 or /specific_attributes/1.json
  def update
    respond_to do |format|
      if @specific_attribute.update(specific_attribute_params)
        format.html { redirect_to specific_attribute_url(@specific_attribute), notice: "Specific attribute was successfully updated." }
        format.json { render :show, status: :ok, location: @specific_attribute }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specific_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specific_attributes/1 or /specific_attributes/1.json
  def destroy
    @specific_attribute.destroy!

    respond_to do |format|
      format.html { redirect_to specific_attributes_url, notice: "Specific attribute was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specific_attribute
      @specific_attribute = SpecificAttribute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def specific_attribute_params
      params.require(:specific_attribute).permit(:description, :need_checkbox, :need_quantity_box, :room_id)
    end
end
