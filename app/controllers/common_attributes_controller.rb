class CommonAttributesController < ApplicationController
  before_action :set_common_attribute, only: %i[ show edit update destroy ]

  # GET /common_attributes or /common_attributes.json
  def index
    @common_attributes = CommonAttribute.all
  end

  # GET /common_attributes/1 or /common_attributes/1.json
  def show
  end

  # GET /common_attributes/new
  def new
    @common_attribute = CommonAttribute.new
  end

  # GET /common_attributes/1/edit
  def edit
  end

  # POST /common_attributes or /common_attributes.json
  def create
    @common_attribute = CommonAttribute.new(common_attribute_params)

    respond_to do |format|
      if @common_attribute.save
        format.html { redirect_to common_attribute_url(@common_attribute), notice: "Common attribute was successfully created." }
        format.json { render :show, status: :created, location: @common_attribute }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @common_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /common_attributes/1 or /common_attributes/1.json
  def update
    respond_to do |format|
      if @common_attribute.update(common_attribute_params)
        format.html { redirect_to common_attribute_url(@common_attribute), notice: "Common attribute was successfully updated." }
        format.json { render :show, status: :ok, location: @common_attribute }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @common_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /common_attributes/1 or /common_attributes/1.json
  def destroy
    @common_attribute.destroy!

    respond_to do |format|
      format.html { redirect_to common_attributes_url, notice: "Common attribute was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_common_attribute
      @common_attribute = CommonAttribute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def common_attribute_params
      params.require(:common_attribute).permit(:description, :need_checkbox, :need_quantity_box)
    end
end
