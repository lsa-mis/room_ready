module DashboardHelper

  def room_check_status_class(checked, total)
    # red for less than 50%
    return 'text-danger' if checked < total * 0.5                                  
    # orange for 50%-89%
    return 'text-warning' if checked >= total * 0.5 && checked < total * 0.9        
    # green for 90% and above
    return 'text-success' if checked >= total * 0.9                                 
    
  end

  def room_check_progress_class(checked, total)
    # red for less than 50%
    return 'bg-danger' if checked < total * 0.5                                  
    # orange for 50%-89%
    return 'bg-warning' if checked >= total * 0.5 && checked < total * 0.9        
    # green for 90% and above
    return 'bg-success' if checked >= total * 0.9                                
  end


  def completion_percentage(checked, total)
    return 0 if total.zero?

    ((checked.to_f / total) * 100).round
  end

  # getter for the number of latest tickets to be displayed on the dashboard, or makes it 5 by default
  def recent_tickets_quantity
    value = AppPreference.find_by(name: "tdx_tickets_quantity_on_dashboard")&.value
    value.presence&.to_i || 5
  end


  def latest_room_tickets
    RoomTicket.includes(room: { floor: :building })
              .order(created_at: :desc)
              .limit(recent_tickets_quantity)
  end

  def rooms_checked_for_date(zone, date)
    date = Date.parse(date) if date.is_a? String 
    RoomState.joins(room: { floor: { building: :zone } } )
             .where(zones: { id: zone.id })
             .where(rooms: { archived: false })
             .where(updated_at: date.beginning_of_day..date.end_of_day)
             .select { |room_state| true } # RoomStatus calculate_percentage
             .count

  end

  def total_rooms(zone)
    Room.active.joins(floor: { building: :zone })
        .where(zones: { id: zone.id })
        .count
  end

  def room_update_log_status(log_note)
    log_note.split("|").first.strip
  end
end
