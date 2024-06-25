module DashboardHelper

  # getter for the number of latest tickets to be displayed on the dashboard, or makes it 5 by default
  def recent_tickets_quantity
    AppPreference.find_by(name: "tdx_tickets_quantity_on_dashboard")&.value || 5
  end


  def latest_room_tickets
    RoomTicket.includes(room: { floor: :building })
              .order(created_at: :desc)
              .limit(recent_tickets_quantity)
  end

end
