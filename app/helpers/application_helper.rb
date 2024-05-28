module ApplicationHelper
  def render_flash_stream
    turbo_stream.update "flash", partial: "layouts/flash"
  end

  def show_date(field)
    field.strftime("%m/%d/%Y") unless field.blank?
  end

  def show_date_with_month_name(field)
    field.to_date.strftime("%B %d, %Y") unless field.blank?
  end
end
