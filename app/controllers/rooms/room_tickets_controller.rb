class Rooms::RoomTicketsController < ApplicationController
  before_action :auth_user
  before_action :set_room_ticket, only: %i[ show ]
  before_action :set_room, only: %i[ new send_email_for_tdx_ticket index ]

  # GET /room_tickets or /room_tickets.json
  def index
    @room_tickets = RoomTicket.where(room_id: @room.id).order(created_at: :desc)
    authorize @room_tickets
  end

  # GET /room_tickets/new
  def new
    @room_ticket = RoomTicket.new
    authorize @room_ticket
  end

  def send_email_for_tdx_ticket
    message = room_ticket_params[:description]
    tdx_email = room_ticket_params[:tdx_email]
    submitter = current_user

    if tdx_emails(@room.floor.building).none? { |_, email| email == tdx_email }
      render json: { errors: ['Invalid TDX email.'] }, status: :unprocessable_entity and return
    end

    @room_ticket = RoomTicket.new(description: message, room_id: @room.id, submitted_by: submitter.uniqname, tdx_email: tdx_email )
    authorize @room_ticket

    respond_to do |format|
      if @room_ticket.save
        RoomTicketMailer.with(date: @room_ticket.created_at.strftime('%m/%d/%Y'), room: @room, message: message, submitter: submitter, tdx_email: tdx_email).send_tdx_ticket.deliver_now
        format.json { render json: { notice: "Room ticket was successfully sent." }, status: :ok }
      else
        format.json { render json: { errors: @room_ticket.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_ticket
      @room_ticket = RoomTicket.find(params[:id])
    end

    def set_room
      # @room_id = params[:room_id]
      @room = Room.find(params[:room_id])
      @building = @room.floor.building
    end

    def room_ticket_params
      params.require(:room_ticket).permit(:description, :tdx_email)
    end
end
