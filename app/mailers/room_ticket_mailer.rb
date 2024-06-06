class RoomTicketMailer < ApplicationMailer
  def send_tdx_ticket
    @message = params[:message]
    @submitter = params[:submitter]
    @room = params[:room]
    @date = params[:date]
    @building = @room.floor.building

    subject = "Issue for Room " + @room.room_number + " in " + @building.name + ", "  + @date
    
    mail(to: "test@gmail.com", subject: subject)
  end
end
