module ApplicationHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

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

  def status_weight(room)
    ca = CommonAttribute.count > 0 ? 1 : 0
    sa = room.specific_attributes.count > 0 ? 1 : 0
    res = room.resources.count 0 ? 1 : 0
    w = 1.to_f / (1 + ca + sa + res) * 100
    return w
  end

  def show_status(room)
    if room.last_time_checked.present?
      last_time_checked = room.last_time_checked.to_date
      tomorrow = Date.today + 1.day
      yesterday = Date.today - 1.day
      if (yesterday..tomorrow).include?(last_time_checked)
        # room is checked today
        room_state = room.room_states.last
        w = status_weight(room)
        percentage = w
        if CommonAttribute.count > 0
          percentage += w if room_state.common_attribute_states.last.present? && (yesterday..tomorrow).include?(room_state.common_attribute_states.last.updated_at.to_date)
        end
        if room.specific_attributes.count > 0
          percentage += w if room_state.specific_attribute_states.last.present? && (yesterday..tomorrow).include?(room_state.specific_attribute_states.last.updated_at.to_date)
        end
        if room.resources.count > 0
          percentage += w if room_state.resources_states.last.present? && (yesterday..tomorrow).include?(room_state.resources_states.last.updated_at.to_date)
        end
        checked = "Checked " + number_with_precision(percentage, precision: 2).to_s + "%"
      else
        checked = "Checked " + time_ago_in_words(last_time_checked + 1.day) + " ago"
      end
    else
      checked = "Never checked"
    end
    return checked
  end

  def us_states
    [
      ['Michigan', 'MI'],
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
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

  def choose_buildings_for_zone
    Building.where(zone: nil).order(:name)
  end

  def show_zone(building)
    if building.zone.present?
      building.zone.name
    else
      ""
    end
  end

end
