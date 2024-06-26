class ReportsController < ApplicationController
  def index
    authorize :report, :index?

    @reports_list = [
      {title: "Room Issues", url: room_issues_report_reports_path },
    ]
  end

  # Design - For each new report:
  # 1) run the logic / activerecord query based on params
  # 2) define a title for the report: @title
  # 3) calculate summary metrics in a hash of description:value pairs : @metrics
  # 4) define an array of headers/column titles: @headers
  # 5) convert the query results into an array of arrays in order same as headers: @data

  def room_issues_report
    authorize :report, :room_issues_report?

    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }

    if params[:commit]
      start_time = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : Date.new(0)
      end_time = params[:to].present? ? Date.parse(params[:to]).end_of_day : Date::Infinity.new

      @rooms = Room.joins(floor: :building).joins(:room_tickets)
                   .where(buildings: { zone_id: params[:zone_id].presence ? params[:zone_id].presence : Zone.all.pluck(:id).push(nil) })
                   .where(room_tickets: { created_at: start_time..end_time })
                   .group('rooms.id')
                   .select('rooms.*, COUNT(room_tickets.id) AS tickets_count')
                   .having('COUNT(room_tickets.id) > 0')
                   .order('tickets_count DESC')

      @title = 'Room Issues Report'
      @metrics = {
        'Total Tickets Count' => @rooms.sum(&:tickets_count),
      }
      @headers = ['Room Number', 'Building', 'Zone', 'Tickets Count']
      @data = @rooms.map do |room|
        [
          room.room_number,
          room.floor.building.name,
          room.floor.building.zone.name,
          room.tickets_count,
        ]
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'room_issues_report.csv', type: 'text/csv' }
    end
  end

  private

  def csv_data
    CSV.generate(headers: true) do |csv|
      csv << [@title]
      csv << []
      @metrics.each do |description, value|
        csv << [description, value]
      end
      csv << []
      csv << @headers
      @data.each do |row|
        csv << row
      end
    end
  end
end
