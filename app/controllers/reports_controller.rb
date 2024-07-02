class ReportsController < ApplicationController
  def index
    authorize :report, :index?

    @reports_list = [
      {title: "Room Issues", url: room_issues_report_reports_path },
      {title: "No Access", url: no_access_report_reports_path },
      {title: "Common Attribute States", url: common_attribute_states_report_reports_path },
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
      zone_id = params[:zone_id].present? ? params[:zone_id] : Zone.all.pluck(:id).push(nil)
      start_time = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : Date.new(0)
      end_time = params[:to].present? ? Date.parse(params[:to]).end_of_day : Date::Infinity.new

      @rooms = Room.joins(floor: :building).joins(:room_tickets)
                   .where(buildings: { zone_id: zone_id })
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

  def no_access_report
    authorize :report, :no_access_report?

    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }

    if params[:commit]
      zone_id = params[:zone_id].present? ? params[:zone_id] : Zone.all.pluck(:id).push(nil)
      start_time = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : Date.new(0)
      end_time = params[:to].present? ? Date.parse(params[:to]).end_of_day : Date::Infinity.new

      @rooms = Room.joins(floor: :building).joins(:room_states)
                   .where(buildings: { zone_id: zone_id })
                   .where(room_states: { updated_at: start_time..end_time })
                   .where(room_states: { is_accessed: false })
                   .group('rooms.id')
                   .select('rooms.*')
                   .select('COUNT(room_states.id) AS na_states_count')
                   .select('array_agg(room_states.updated_at) as na_states_dates')
                   .select('array_agg(room_states.no_access_reason) as na_states_reasons')
                   .having('COUNT(room_states.id) > 0')
                   .order('na_states_count DESC')

      @title = 'No Access Report'
      @metrics = {
        'Total No Access Count' => @rooms.sum(&:na_states_count)
      }
      @headers = ['Room Number', 'Building', 'Zone', 'No Access Count', 'Dates and Reasons for No Access (Most Recent 5)']
      @data = @rooms.map do |room|
        [
          room.room_number,
          room.floor.building.name,
          room.floor.building.zone.name,
          room.na_states_count,
          room.na_states_dates.zip(room.na_states_reasons)
                          .sort_by { |date, _reason| date }
                          .reverse
                          .first(5)
                          .map { |date, reason| "#{date.strftime('%m/%d/%y')} (#{reason})" }
                          .join(', ')
        ]
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'no_access_report.csv', type: 'text/csv' }
    end
  end

  def common_attribute_states_report
    authorize :report, :common_attribute_states_report?

    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }

    if params[:commit]
      zone_id = params[:zone_id].present? ? params[:zone_id] : Zone.all.pluck(:id).push(nil)
      start_time = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : Date.new(0)
      end_time = params[:to].present? ? Date.parse(params[:to]).end_of_day : Date::Infinity.new

      @rooms = Room.joins(floor: :building).joins(room_states: { common_attribute_states: :common_attribute })
                   .where(buildings: { zone_id: zone_id })
                   .where(room_states: { updated_at: start_time..end_time })
                   .select('rooms.*, room_states.updated_at,common_attribute_states.checkbox_value as checkbox_value, common_attribute_states.quantity_box_value as quantity_box_value, common_attributes.description as common_attribute_description')

      @grouped_rooms = @rooms.group_by { |room| room.common_attribute_description }

      @grouped = true

      @title = 'Common Attribute States Report'
      @metrics = {
        # 'Total No Access Count' => @rooms.sum(&:na_states_count)
      }
      earliest_date = @rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.min
      latest_date = @rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.max

      header_start = start_time == Date.new(0) ? earliest_date.to_date : start_time.to_date
      header_end = end_time == Date::Infinity.new ? latest_date.to_date : end_time.to_date
      @headers = ['Room'] + (header_start..header_end).to_a

      @data = @grouped_rooms.transform_values do |rooms|
        pivot_table = Hash.new { |hash, key| hash[key] = Hash.new(nil) }
        rooms.each do |room|
          pivot_table[room.room_number][room.updated_at.to_date] = ["#{room.checkbox_value}  #{room.quantity_box_value}"]
        end
        pivot_table
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'common_attribute_states_report.csv', type: 'text/csv' }
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
