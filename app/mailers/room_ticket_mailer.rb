class RoomTicketMailer < ApplicationMailer
  def send_tdx_ticket
    @message = params[:message]
    @submitter = params[:submitter]
    @room = params[:room_id]
    @date = params[:date]

    subject = "Issue for Room " + @room + ", "  + @date
    
    mail(to: "test@gmail.com", subject: subject)
  end
end
