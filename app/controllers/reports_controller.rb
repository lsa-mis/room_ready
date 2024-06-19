class ReportsController < ApplicationController
  def index
    authorize :report, :index?
  end

  def room_issues_report
    authorize :report, :room_issues_report?

    end_time = Time.current.end_of_day
    start_time = case params[:time_frame]&.to_i
      when 0 then 1.week.ago.beginning_of_day
      when 1 then 1.month.ago.beginning_of_day
      when 2 then 3.month.ago.beginning_of_day
      when 3 then 6.month.ago.beginning_of_day
      when 4 then 1.year.ago.beginning_of_day
    end

    @tickets = RoomTicket.all

    @rooms = Room.joins(floor: :building).joins(:room_tickets)
                 .where(buildings: { zone_id: params[:zone_id].presence ? params[:zone_id].presence : Zone.all.pluck(:id).push(nil) })
                 .where(room_tickets: { created_at: start_time..end_time })
                 .group('rooms.id')
                 .select('rooms.*, COUNT(room_tickets.id) AS tickets_count')
                 .having('COUNT(room_tickets.id) > 0')
                 .order('tickets_count DESC')


    

    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }

    @time_frames = [ ["1 week", 0], ["1 month", 1], ["3 month", 2], ["6 months", 3], ["1 yr", 4] ]
  end

  
end
