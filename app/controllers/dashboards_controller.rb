class DashboardsController < ApplicationController
  before_action :auth_user

  def index
    @dashboard = Dashboard.new
    authorize @dashboard

    @zones = Zone.all

    @room_access_data = {
      "Not accessed for 3 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
      .where('updated_at >= ?', 3.days.ago.beginning_of_day)
      .where('updated_at < ?', 2.days.ago.beginning_of_day).count,

      "Not accessed for 4 to 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""])
      .where('updated_at >= ?', 7.days.ago.end_of_day)
      .where('updated_at < ?', 3.days.ago.beginning_of_day).count,

      "Not accessed for over 7 days": RoomState.where(is_accessed: false).where.not(no_access_reason: [nil, ""]).where('updated_at < ?', 7.days.ago.beginning_of_day).count
    }

    @room_check_in_data = {
    "Not checked for 3 days": Room.left_outer_joins(:room_states)
      .where(room_states: { id: nil })
      .or(
        Room.left_outer_joins(:room_states)
            .where('room_states.created_at >= ?', 3.days.ago.beginning_of_day)
            .where('room_states.created_at < ?', 2.days.ago.beginning_of_day)
      )
      .distinct.count,

    "Not checked for 4 to 7 days": Room.left_outer_joins(:room_states)
      .where(room_states: { id: nil })
      .or(
        Room.left_outer_joins(:room_states)
            .where('room_states.created_at < ?', 4.days.ago.beginning_of_day)
            .where('room_states.created_at >= ?', 7.days.ago.beginning_of_day)
      )
      .distinct.count,

    "Not checked for over 7 days": Room.left_outer_joins(:room_states)
      .where(room_states: { id: nil })
      .or(
        Room.left_outer_joins(:room_states)
            .where('room_states.created_at < ?', 7.days.ago.beginning_of_day)
      )
      .distinct.count
    }
    
  end

  def new
  end

  def edit
  end

  def show
  end

  def delete
  end
end
