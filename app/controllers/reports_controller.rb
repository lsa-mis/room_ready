class ReportsController < ApplicationController
  def index
    authorize :report, :index?

    @reports_list = [
      {title: "Room Issues", url: room_issues_report_reports_path },
    ]
  end

  def room_issues_report
    authorize :report, :room_issues_report?

    start_time = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : Date.new(0)
    end_time = params[:to].present? ? Date.parse(params[:to]).end_of_day : Date::Infinity.new

    if params[:commit]
      @rooms = Room.joins(floor: :building).joins(:room_tickets)
                   .where(buildings: { zone_id: params[:zone_id].presence ? params[:zone_id].presence : Zone.all.pluck(:id).push(nil) })
                   .where(room_tickets: { created_at: start_time..end_time })
                   .group('rooms.id')
                   .select('rooms.*, COUNT(room_tickets.id) AS tickets_count')
                   .having('COUNT(room_tickets.id) > 0')
                   .order('tickets_count DESC')

      @total_tickets_count = @rooms.sum(&:tickets_count)
    end

    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }
  end
end
