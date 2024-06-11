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
