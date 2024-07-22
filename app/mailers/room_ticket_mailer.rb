class RoomTicketMailer < ApplicationMailer
  def send_tdx_ticket
    @message = params[:message]
    @submitter = params[:submitter]
    @room = params[:room]
    @date = params[:date]
    @building = @room.floor.building
    tdx_email = params[:tdx_email]
    from = issue_email_from_address
    @forward_to_lsa_ts_group = AppPreference.find_by(name: 'tdx_lsa_ts_email').value.include?(tdx_email) ? "Please forward this ticket to LSA-TS-Classrooms-UrgentSupport." : ""

    subject = "Issue for Room " + @room.room_number + " in " + @building.name + ", "  + @date
    
    mail(to: tdx_email, subject: subject, from: from)
  end

  def issue_email_from_address
    if AppPreference.find_by(name: 'issue_email_from_address').value.present?
      AppPreference.find_by(name: 'issue_email_from_address').value
    else
      "lsa-spaceready-admins@umich.edu"
    end
  end

end
