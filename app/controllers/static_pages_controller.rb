class StaticPagesController < ApplicationController
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
    selected_date = if params[:dashboard_date].present?
        Date.parse(params[:dashboard_date]).in_time_zone.change(hour: 22)
      else
        Time.zone.today
      end

    @zones = Zone.all

    @room_access_data = {
      "Not accessed for 3 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
      .where('updated_at >= ?', selected_date - 3.days)
      .where('updated_at < ?', selected_date - 2.days).count,

      "Not accessed for 4 to 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
      .where('updated_at >= ?', selected_date - 7.days)
      .where('updated_at < ?', selected_date - 3.days).count,

      "Not accessed for over 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""]).where('updated_at < ?', selected_date - 7.days).count
    }

    @room_check_in_data = {
    "Not checked for 3 days": Room.joins(floor: :building)
      .left_outer_joins(:room_states)
      .where(buildings: { zone_id: !nil })
      .where(room_states: { id: nil })
      .or(
        Room.joins(floor: :building)
            .left_outer_joins(:room_states)
            .where(buildings: { zone_id: !nil })
            .where('room_states.created_at >= ?', selected_date - 3.days)
            .where('room_states.created_at < ?', selected_date - 2.days)
      )
      .distinct.count,

    "Not checked for 4 to 7 days": Room.joins(floor: :building)
      .left_outer_joins(:room_states)
      .where(buildings: { zone_id: !nil })
      .where(room_states: { id: nil })
      .or(
        Room.joins(floor: :building)
            .left_outer_joins(:room_states)
            .where(buildings: { zone_id: !nil })
            .where('room_states.created_at < ?', selected_date - 4.days)
            .where('room_states.created_at >= ?', selected_date - 7.days)
      )
      .distinct.count,

    "Not checked for over 7 days": Room.joins(floor: :building)
      .left_outer_joins(:room_states)
      .where(buildings: { zone_id: !nil })
      .where(room_states: { id: nil })
      .or(
        Room.joins(floor: :building)
            .left_outer_joins(:room_states)
            .where(buildings: { zone_id: !nil })
            .where('room_states.created_at < ?', selected_date - 7.days)
      )
      .distinct.count
}
    
  end

end
