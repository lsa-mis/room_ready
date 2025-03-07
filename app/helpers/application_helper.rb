module ApplicationHelper

  def root_path
    if user_signed_in?
      if is_admin?
        dashboard_path
      elsif is_rover?
        welcome_rovers_path
      else
        all_root_path
      end
    else
      all_root_path
    end
  end

  def render_flash_stream
    turbo_stream.update "flash", partial: "layouts/flash"
  end
  
  def show_date(field)
    field.strftime("%m/%d/%Y") unless field.blank?
  end

  def show_date_with_month_name(field)
    field.to_date.strftime("%B %d, %Y") unless field.blank?
  end

  def show_date_with_time(field)
    field.to_datetime.strftime("%B %d, %Y at %I:%M%p") unless field.blank?
  end

  def is_rover?
    session[:role] == "rover"
  end

  def is_admin?
    session[:role] == "developer" || session[:role] == "admin"
  end

  def is_readonly?
    session[:role] == "readonly"
  end

  def choose_buildings_for_zone
    Building.active.where(zone: nil).collect { |b| [b.name, b.id] }
  end

  def show_zone(building)
    if building.zone.present?
      building.zone.name
    else
      "N/A"
    end
  end

  def google_map_navigation_path(address)
    formatted_address = address.gsub(/\s/,'+')
    "https://www.google.com/maps/search/?api=1&query=" + formatted_address
  end

  def show_room_percentage(room)
    RoomStatus.new(room).calculate_percentage
  end

  def tdx_emails(building)
    emails = []
    if AppPreference.find_by(name: 'tdx_facilities_email').value.present?
      value =  AppPreference.find_by(name: 'tdx_facilities_email')&.value&.split(':').map(&:strip)
      facility_email = [value[0], value[1]]
    end
    if AppPreference.find_by(name: 'tdx_lsa_ts_email').value.present?
      value = AppPreference.find_by(name: 'tdx_lsa_ts_email')&.value&.split(':').map(&:strip)
      emails << [value[0], value[1]]
    else
      emails << "No LSA TS Help desk email in the App Preferences - report an issue"
    end
    case building.nick_name&.downcase
    when "dana"
      if AppPreference.find_by(name: 'dana_building_facility_issues_email').value.present?
        value =  AppPreference.find_by(name: 'dana_building_facility_issues_email')&.value&.split(':').map(&:strip)
        emails << [value[0], value[1]]
      else
        emails << facility_email
      end
    when "skb"
      if AppPreference.find_by(name: 'skb_facility_issues_email').value.present?
        value =  AppPreference.find_by(name: 'skb_facility_issues_email')&.value&.split(':').map(&:strip)
        emails << [value[0], value[1]]
      else
        emails << facility_email
      end
    else
      emails << facility_email
    end
    return emails
  end

  def show_supervisor_phone
    if AppPreference.find_by(name: 'supervisor_phone_number').present? && AppPreference.find_by(name: 'supervisor_phone_number').value.present?
      "at " + AppPreference.find_by(name: 'supervisor_phone_number').value
    else 
      ""
    end
  end

  def show_user_name_by_id(id)
    User.find(id).display_name
  end

  def has_archived_rooms?(building)
    building.floors.each do |floor|
      if floor.archived_rooms.present?
        return true
      end
    end
    return false
  end

  def show_building_status(building)
    rooms = building.active_rooms
    return "Never checked" unless building.has_checked_active_rooms?

    statuses = []
    rooms.each do |r|
      room_status = RoomStatus.new(r)
      if room_status.room_checked_today? 
        statuses << room_status.calculate_percentage.to_i
      end
    end
    if statuses.present?
      "Checked #{(statuses.sum(0.0) / rooms.size).round}%"
    else
      "Not checked today"
    end
  end

  def room_tickets(room, day)
    RoomTicket.where('room_id = ? AND DATE(updated_at) = ?', room.id, day.to_date)
  end

  def room_recent_tickets(room)
    RoomTicket.where('room_id = ? AND DATE(updated_at) > ?', room.id, Date.today - 5.day)
  end
  
end
