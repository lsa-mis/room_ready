class StaticPagesController < ApplicationController
  include DashboardHelper
  before_action :auth_user, only: %i[ dashboard welcome_rovers ]

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

    @selected_date = params[:dashboard_date].present? ? Date.parse(params[:dashboard_date]) : Date.today
    @zones = Zone.all.order(:name)
    active_rooms = Room.active_in_zones
    
    @room_access_data = {
      "Not accessed 3 times": rooms_not_accessed_for_number_of_times(active_rooms, 3).count,
      "Not accessed 5 times": rooms_not_accessed_for_number_of_times(active_rooms, 5).count,
      "Not accessed 7 times": rooms_not_accessed_for_number_of_times(active_rooms, 7).count
    }

    @rooms_not_checked_in_3_days = active_rooms.where('DATE(last_time_checked) < ?', 3.days.ago.to_date)
    @rooms_not_checked_4_to_7_days = active_rooms.where('DATE(last_time_checked) >= ? AND DATE(last_time_checked) < ?', 7.days.ago.to_date, 3.days.ago.to_date)
    @rooms_not_checked_7_plus_days = active_rooms.where('DATE(last_time_checked) < ?', 7.days.ago.to_date)
    @rooms_never_checked = active_rooms.where(last_time_checked: nil)

    @room_check_in_data = {
      "Not checked for 3 days" => @rooms_not_checked_in_3_days.count,
      "Not checked for 4 to 7 days" => @rooms_not_checked_4_to_7_days.count,
      "Not checked for over 7 days" => @rooms_not_checked_7_plus_days.count,
      "Never checked" => @rooms_never_checked.count
    }

    last_room_states = RoomState.all.order(updated_at: :desc).limit(5)
    @last_checked_rooms = last_room_states.map { |room_state| [Room.find(room_state.room_id), room_state.updated_at] }

    @latest_room_tickets = RoomTicket.latest

    @room_update_log = RoomUpdateLog.last
    @room_update_log_status = @room_update_log.status
    
  end

  private

  def rooms_not_accessed_for_number_of_times(active_rooms, number)
    result_rooms = []
    active_rooms.each do |room|
      states = room.room_states.order('updated_at DESC').limit(number).pluck(:is_accessed)
      if states.length == number && (states.all? false)
        result_rooms << room
      end
    end
    return result_rooms
  end

end
