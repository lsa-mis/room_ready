class CommonAttributesController < ApplicationController
  before_action :auth_user
  before_action :set_common_attribute, only: %i[edit update destroy ]

  # GET /common_attributes or /common_attributes.json
  def index
    @common_attributes = CommonAttribute.all
    @new_common_attribute = CommonAttribute.new
    authorize @common_attributes
  end

  # GET /common_attributes/new
  def new
    @common_attribute = CommonAttribute.new
    authorize @common_attribute
  end

  # GET /common_attributes/1/edit
  def edit
  end

  # POST /common_attributes or /common_attributes.json
  def create
    @common_attribute = CommonAttribute.new(common_attribute_params)
    authorize @common_attribute

    respond_to do |format|
      if @common_attribute.save
        notice = "Common attribute was successfully created."
        format.turbo_stream do
          @new_common_attribute = CommonAttribute.new
          flash.now[:notice] = notice
        end
        format.html { redirect_to common_attributes_path, notice: notice }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /common_attributes/1 or /common_attributes/1.json
  def update
    respond_to do |format|
      if @common_attribute.update(common_attribute_params)
        format.html { redirect_to common_attributes_path, notice: "Common attribute was successfully updated." }
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
      notice = "Common attribute was successfully deleted."
      format.turbo_stream do
        flash.now[:notice] = notice
      end
      format.html { redirect_to common_attributes_url, notice: notice }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_common_attribute
      @common_attribute = CommonAttribute.find(params[:id])
      authorize @common_attribute
    end

    # Only allow a list of trusted parameters through.
    def common_attribute_params
      params.require(:common_attribute).permit(:description, :need_checkbox, :need_quantity_box)
    end
end
