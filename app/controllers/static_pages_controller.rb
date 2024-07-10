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
      "Not accessed for 3 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
      .where('updated_at >= ?', Date.today - 3.days)
      .where('updated_at < ?', Date.today - 2.days).count,

      "Not accessed for 4 to 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
      .where('updated_at >= ?', Date.today - 7.days)
      .where('updated_at < ?', Date.today - 3.days).count,

      "Not accessed for over 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""]).where('updated_at < ?', Date.today - 7.days).count
    }

    @room_check_in_data = {
    "Not checked for 3 days": Room.joins(floor: :building)
      .left_outer_joins(:room_states)
      .where.not(buildings: { zone_id: nil })
      .where(room_states: { id: nil })
      .or(
        Room.joins(floor: :building)
            .left_outer_joins(:room_states)
            .where.not(buildings: { zone_id: nil })
            .where('room_states.created_at >= ?', Date.today - 3.days)
            .where('room_states.created_at < ?', Date.today - 2.days)
      )
      .distinct.count,

    "Not checked for 4 to 7 days": Room.joins(floor: :building)
      .left_outer_joins(:room_states)
      .where.not(buildings: { zone_id: nil })
      .where(room_states: { id: nil })
      .or(
        Room.joins(floor: :building)
            .left_outer_joins(:room_states)
            .where.not(buildings: { zone_id: nil })
            .where('room_states.created_at < ?', Date.today - 4.days)
            .where('room_states.created_at >= ?', Date.today - 7.days)
      )
      .distinct.count,

    "Not checked for over 7 days": Room.joins(floor: :building)
      .left_outer_joins(:room_states)
      .where.not(buildings: { zone_id: nil })
      .where(room_states: { id: nil })
      .or(
        Room.joins(floor: :building)
            .left_outer_joins(:room_states)
            .where.not(buildings: { zone_id: nil })
            .where('room_states.created_at < ?', Date.today - 7.days)
      )
      .distinct.count
}
    
  end

end
