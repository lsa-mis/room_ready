class RoomTicketsController < ApplicationController
  before_action :auth_user
  before_action :set_room_ticket, only: %i[ show edit update destroy ]

  # GET /room_tickets or /room_tickets.json
  def index
    @room_tickets = RoomTicket.all
    authorize @room_tickets
  end

  # GET /room_tickets/1 or /room_tickets/1.json
  def show
  end

  # GET /room_tickets/new
  def new
    @room_ticket = RoomTicket.new
    authorize @room_ticket
  end

  # GET /room_tickets/1/edit
  def edit
  end

  # POST /room_tickets or /room_tickets.json
  def create
    @room_ticket = RoomTicket.new(room_ticket_params)

    respond_to do |format|
      if @room_ticket.save
        format.html { redirect_to room_ticket_url(@room_ticket), notice: "Room ticket was successfully created." }
        format.json { render :show, status: :created, location: @room_ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_tickets/1 or /room_tickets/1.json
  def update
    respond_to do |format|
      if @room_ticket.update(room_ticket_params)
        format.html { redirect_to room_ticket_url(@room_ticket), notice: "Room ticket was successfully updated." }
        format.json { render :show, status: :ok, location: @room_ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_tickets/1 or /room_tickets/1.json
  def destroy
    @room_ticket.destroy!

    respond_to do |format|
      format.html { redirect_to room_tickets_url, notice: "Room ticket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def send_email_for_tdx_ticket
    fail
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_ticket
      @room_ticket = RoomTicket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_ticket_params
      params.require(:room_ticket).permit(:description, :submitted_by, :submitted_at, :room_id)
    end
end
