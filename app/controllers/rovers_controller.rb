class RoversController < ApplicationController
  before_action :set_rover, only: %i[ show edit update destroy ]

  # GET /rovers or /rovers.json
  def index
    @rovers = Rover.all
  end

  # GET /rovers/1 or /rovers/1.json
  def show
  end

  # GET /rovers/new
  def new
    @rover = Rover.new
  end

  # GET /rovers/1/edit
  def edit
  end

  # POST /rovers
  def create
    uniqname = rover_params[:uniqname]
    result = get_rover_info(uniqname)
    @rover = Rover.new(rover_params)
    authorize @rover #not sure if we need this for rover
    if result['valid'] 
      @rover.first_name = result['first_name']
      @rover.last_name = result['last_name']
      # respond_to do |format|
        if @rover.save 
          flash.now[:notice] = result['note'] + "Rover was successfully created."
          redirect_to rover_url(@rover), notice: "Rover was successfully created."
          # format.html { redirect_to rover_url(@rover), notice: "Rover was successfully created." }
        else
          render :new, status: :unprocessable_entity
          # format.html { render :new, status: :unprocessable_entity }
        end
      # end
    else
      flash.now[:alert] = result['note']
      # return #why do we need it here?
    end
  end

  # PATCH/PUT /rovers/1 or /rovers/1.json
  def update
    respond_to do |format|
      if @rover.update(rover_params)
        format.html { redirect_to rover_url(@rover), notice: "Rover was successfully updated." }
        format.json { render :show, status: :ok, location: @rover }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rover.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rovers/1 or /rovers/1.json
  def destroy
    @rover.destroy!

    respond_to do |format|
      format.html { redirect_to rovers_url, notice: "Rover was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_rover_info(uniqname)
    result = {'valid' => false, 'note' => '', 'last_name' => '', 'first_name' => ''}
    valid = LdapLookup.uid_exist?(uniqname)
    if valid
      name = LdapLookup.get_simple_name(uniqname)
        result['valid'] =  true
        if name.include?("No displayname")
          result['note'] = " Mcommunity returns no name for '#{uniqname}' uniqname. Please add first and last names manually."
        else
          result['first_name'] = name.split(" ").first
          result['last_name'] = name.split(" ").last
          result['note'] = "Uniqname is valid"
        end
    else
      result['note'] = "The '#{uniqname}' uniqname is not valid."
    end
    return result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rover
      @rover = Rover.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rover_params
      params.require(:rover).permit(:uniqname, :first_name, :last_name)
    end
end
