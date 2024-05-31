module ApplicationHelper

  def root_path
    if user_signed_in?
      if is_admin?(current_user)
        dashboard_path
      elsif is_rover?(current_user)
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

  def is_rover?(current_user)
    Rover.exists?(uniqname: current_user.uniqname)
  end

  def is_admin?(user)
    user.membership.present?
  end

end
