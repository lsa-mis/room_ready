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
      "Not accessed for 3 days": rooms_not_accessed_for_number_of_days(3).count,
      "Not accessed for 5 days": rooms_not_accessed_for_number_of_days(5).count,
      "Not accessed for 7 days": rooms_not_accessed_for_number_of_days(7).count
    }

    # @room_access_data = {
    #   "Not accessed for 3 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
    #   .where('updated_at >= ?', Date.today - 3.days)
    #   .where('updated_at < ?', Date.today - 2.days).count,

    #   "Not accessed for 4 to 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
    #   .where('updated_at >= ?', Date.today - 7.days)
    #   .where('updated_at < ?', Date.today - 3.days).count,

    #   "Not accessed for over 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""]).where('updated_at < ?', Date.today - 7.days).count
    # }
    # 
    @rooms_not_checked_in_3_days = Room.active.where('DATE(last_time_checked) = ?', 3.days.ago.to_date)
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
  def rooms_not_accessed_for_number_of_days(number)
    result_rooms = []
    rooms = Room.active.joins(floor: :building)
      .where.not(buildings: { zone_id: nil })
    rooms.each do |room|

      # states = room.room_states.reverse.pluck(:is_accessed, :updated_at)[..number]
      states = room.room_states.order('updated_at DESC').limit(number + 1).pluck(:is_accessed, :updated_at)
      if states.length == number + 1
        result = Array.new(number, false) + [true]
        if states.map { |item| item[0] } == result  && states[number][1].to_date == Date.today - number.day
          result_rooms << room
        end
      end
    end
    return result_rooms
  end

end
