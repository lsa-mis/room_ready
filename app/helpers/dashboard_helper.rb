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

  def rooms_checked_for_date(zone, date)
    date = Date.parse(date) if date.is_a? String 
    RoomState.joins(room: { floor: { building: :zone } } )
             .where(zones: { id: zone.id })
             .where(rooms: { archived: false })
             .where(updated_at: date.beginning_of_day..date.end_of_day)
             .select { |room_state| true } # RoomStatus calculate_percentage
             .count

  end
end
