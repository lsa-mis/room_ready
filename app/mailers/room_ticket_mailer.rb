class RoomTicketMailer < ApplicationMailer
  def send_tdx_ticket
    subject = params[:subject]
    @message = params[:message]
    mail(to: "test@gmail.com", subject: subject)
  end
end