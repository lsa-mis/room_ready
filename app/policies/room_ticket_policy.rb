class RoomTicketPolicy < ApplicationPolicy

  def new?
    send_email_for_tdx_ticket?
  end

  def send_email_for_tdx_ticket?
    is_rover? || is_admin?
  end
end
