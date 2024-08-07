class RoomTicketMailer < ApplicationMailer
  def send_tdx_ticket
    @message = params[:message]
    @submitter = params[:submitter]
    @room = params[:room]
    @date = params[:date]
    @building = @room.floor.building
    tdx_email = params[:tdx_email]
    subject = "Issue for Room " + @room.room_number + " in " + @building.name + ", "  + @date
    mail(to: tdx_email, subject: subject)
  end

end
