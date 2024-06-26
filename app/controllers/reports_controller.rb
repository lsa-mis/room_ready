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

      @title = 'Room Issues Report'
      @headers = ['Room Number', 'Building', 'Zone', 'Tickets Count']
      @data = @rooms.map do |room|
        [
          room.room_number,
          room.floor.building.name,
          room.floor.building.zone.name,
          room.tickets_count,
        ]
      end

      @metrics = {
        'Total Tickets Count' => @rooms.sum(&:tickets_count),
      }
    end

    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'room_issues_report.csv', type: 'text/csv' }
    end


  end

  private

  # Design
  # 1) run the query based on params
  # 2) format in a table view
  # 3) add list of headers/titles
  # 4) calculate cumulative metrics
  # 5) export to csv/display in browser
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
