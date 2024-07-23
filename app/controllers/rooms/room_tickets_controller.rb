class Rooms::RoomTicketsController < ApplicationController
  before_action :auth_user
  before_action :set_room, only: %i[ send_email_for_tdx_ticket ]

  def send_email_for_tdx_ticket
    message = room_ticket_params[:description]
    tdx_email = room_ticket_params[:tdx_email]

    if tdx_emails(@room.floor.building).none? { |_, email| email == tdx_email }
      render json: { errors: ['Invalid email address.'] }, status: :unprocessable_entity and return
    end

    @room_ticket = RoomTicket.new(description: message, room_id: @room.id, submitted_by: current_user.uniqname, tdx_email: tdx_email )
    authorize @room_ticket

    respond_to do |format|
      if @room_ticket.save
        RoomTicketMailer.with(date: @room_ticket.created_at.strftime('%m/%d/%Y'), room: @room, message: message, submitter: current_user, tdx_email: tdx_email).send_tdx_ticket.deliver_now
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
      @room = Room.find(params[:room_id])
      @building = @room.floor.building
    end

    def room_ticket_params
      params.require(:room_ticket).permit(:description, :tdx_email)
    end
end
