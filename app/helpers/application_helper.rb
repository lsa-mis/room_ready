module ApplicationHelper
  include FloorSortable

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
    errors = []
    lsa_ts_pref = AppPreference.find_by(name: 'tdx_lsa_ts_email')
    lsa_ts_email, error = tdx_pref_to_email(
      lsa_ts_pref, type: "LSA TS",
      error_message: "No LSA TS Help desk email in the App Preferences - inform supervisor"
    )
    if error.present?
      errors << error
    else
      emails << lsa_ts_email
    end

    facilities_pref = AppPreference.find_by(name: 'tdx_facilities_email')
    facility_email, error = tdx_pref_to_email(
       facilities_pref, type: "LSA Facilities",
       error_message: "No LSA Facilities Help desk email in the App Preferences - inform supervisor"
    )
    if error.present?
      errors << error
    end
    error = nil
    case building.nick_name&.downcase
    when "dana"
      dana_pref = AppPreference.find_by(name: 'dana_building_facility_issues_email')
      building_email, error = tdx_pref_to_email(
        dana_pref, type: "Dana Building Facilities",
        error_message: "No Dana Building Facilities Help desk email in the App Preferences - inform supervisor"
      )
    when "skb"
      skb_pref = AppPreference.find_by(name: 'skb_facility_issues_email')
      building_email, error = tdx_pref_to_email(
        skb_pref, type: "SKB Facilities",
        error_message: "No SKB Facilities Help desk email in the App Preferences - inform supervisor"
      )
    when "pharm"
      pharmacy_pref = AppPreference.find_by(name: 'pharmacy_building_facility_issues_email')
      building_email, error = tdx_pref_to_email(
        pharmacy_pref, type: "Pharmacy Building Facilities",
        error_message: "No Pharmacy Building Facilities Help desk email in the App Preferences - inform supervisor"
      )
    else
      building_email = facility_email
    end
    if error.present?
      errors << error
    elsif building_email.is_a?(Array) && building_email.length == 2
      emails << building_email
    end
    fail
    return emails, errors
  end

  def tdx_pref_to_email(pref, type: "", error_message: nil)
    if pref&.value.present?
      value = pref.value.split(':').map(&:strip)
      
      if value.length >= 2 && value[1].present?
        if valid_email?(value[1])
          [[value[0], value[1]], nil]
        else
          [[], type + ": Invalid email format in App Preferences - inform supervisor"]
        end
      else
        [[], error_message.presence || "Invalid email format in App Preferences - inform supervisor"]
      end
    else
      [[], error_message.presence || "No email in App Preferences - inform supervisor"]
    end
  end

  private

  def valid_email?(email)
    email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end

  def tdx_pref_to_email(pref, default_pair)
    if pref&.value.present?
      value = pref.value.split(':').map(&:strip)
      [value[0], value[1]]
      if value.length >= 2 && value[1].present?
        [value[0], value[1]]
      else
        default_pair
      end
    else
      default_pair
    end
  end

  def show_supervisor_phone
    supervisor_pref = AppPreference.find_by(name: 'supervisor_phone_number')
    if supervisor_pref&.value.present?
      "at " + supervisor_pref.value
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
