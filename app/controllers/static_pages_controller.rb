class StaticPagesController < ApplicationController
  include DashboardHelper
  before_action :auth_user, only: %i[ dashboard welcome_rovers ]

  def dashboard
    authorize :static_page
  end

  def about
    authorize :static_page
    @about_page_announcement = Announcement.find_by(location: "about_page")
    
  end

  def welcome_rovers
    authorize :static_page
    @rovers_welcome_page_announcement = Announcement.find_by(location: "rovers_welcome_page")
  end

  def dashboard
    authorize :static_page
    @room_update_log = RoomUpdateLog.last

    @selected_date = params[:dashboard_date].present? ? Date.parse(params[:dashboard_date]) : Date.today

    @latest_tickets = latest_room_tickets

    @zones = Zone.all.order(:name)

    @room_access_data = {
      "Not accessed 3 times": rooms_not_accessed_for_number_of_times(3).count,
      "Not accessed 5 times": rooms_not_accessed_for_number_of_times(5).count,
      "Not accessed 7 times": rooms_not_accessed_for_number_of_times(7).count
    }

    @rooms_not_checked_in_3_days = Room.active.where('DATE(last_time_checked) < ?', 3.days.ago.to_date)
    @rooms_not_checked_4_to_7_days = Room.active.where('DATE(last_time_checked) >= ? AND DATE(last_time_checked) < ?', 7.days.ago.to_date, 3.days.ago.to_date)
    @rooms_not_checked_7_plus_days = Room.active.where('DATE(last_time_checked) < ?', 7.days.ago.to_date)
    @rooms_never_checked = Room.active.where(last_time_checked: nil)

    @room_check_in_data = {
      "Not checked for 3 days" => @rooms_not_checked_in_3_days.count,
      "Not checked for 4 to 7 days" => @rooms_not_checked_4_to_7_days.count,
      "Not checked for over 7 days" => @rooms_not_checked_7_plus_days.count,
      "Never checked" => @rooms_never_checked.count
    }
    
  end

  private

  def rooms_not_accessed_for_number_of_times(number)
    result_rooms = []
    rooms = Room.active.joins(floor: :building)
      .where.not(buildings: { zone_id: nil })
    rooms.each do |room|
      states = room.room_states.order('updated_at DESC').limit(number).pluck(:is_accessed)
      if states.length == number && (states.all? false)
        result_rooms << room
      end
    end
    return result_rooms
  end

end
