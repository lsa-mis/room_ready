class Rooms::RoomTicketsController < ApplicationController
  before_action :auth_user
  before_action :set_room_ticket, only: %i[ show ]
  before_action :set_room, only: %i[ new send_email_for_tdx_ticket ]

  # GET /room_tickets or /room_tickets.json
  def index
    @room_tickets = RoomTicket.all
    authorize @room_tickets
  end

  # GET /room_tickets/new
  def new
    @room_ticket = RoomTicket.new
    @building = @room.floor.building
    authorize @room_ticket
  end

  def send_email_for_tdx_ticket
    message = params.require(:room_ticket).permit(:description)[:description]
    submitter = current_user

    @room_ticket = RoomTicket.new(description: message, room_id: @room.id, submitted_by: submitter )
    authorize @room_ticket

    respond_to do |format|
      if @room_ticket.save
        RoomTicketMailer.with(date: @room_ticket.created_at.strftime('%m/%d/%Y'), room: @room, message: message, submitter: submitter).send_tdx_ticket.deliver_now
        format.html { redirect_to room_room_tickets_path, notice: "Room ticket was successfully sent." }
        format.json { render :show, status: :created, location: @room_ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_ticket
      @room_ticket = RoomTicket.find(params[:id])
    end

    def set_room
      @room_id = params[:room_id]
      @room = Room.find(params[:room_id])
    end
end
