class ReportsController < ApplicationController
  before_action :set_form_values, :collect_form_params

  def index
    authorize :report, :index?

    @reports_list = [
      {title: "Room Issues", url: room_issues_report_reports_path },
      {title: "Inspection Rate", url: inspection_rate_report_reports_path },
      {title: "No Access", url: no_access_report_reports_path },
      {title: "Common Attribute States", url: common_attribute_states_report_reports_path },
      {title: "Specific Attribute States", url: specific_attribute_states_report_reports_path },
      {title: "Resource States", url: resource_states_report_reports_path },
    ]
  end

  # Design - For each new report:
  # 1) run the logic / activerecord query based on params
  # 2) if there is no record returned, do none of the below
  # 3) define a title for the report: @title
  # 4) calculate summary metrics in a hash of description:value pairs : @metrics
  # 5) for a basic report:
  #   a) define an array of headers/column titles: @headers
  #   b) convert the query results into an array of arrays in order same as headers: @data
  # 6) for a grouped pivot-table report (w/ dates as columns):
  #   a) set @grouped = true
  #   b) define an array of date headers: @date_headers
  #   c) define an array of all headers (indluding date headers): @headers
  #   d) convert the query results into a grouped hash of hashes: @data
  #     i) the first key should be an array of 'grouped' keys, like for e.g [zone, building, room]
  #     ii) the second key should be the date
  #     iii) the value should be the cell value
  #     iv) for e.g: @data[[Zone, Building, Room]][Date] = Value

  def room_issues_report
    authorize :report, :room_issues_report?

    if params[:commit]
      zone_id, building_id, start_time, end_time = collect_form_params

      rooms = Room.active
                  .joins(floor: :building).joins(:room_tickets)
                  .where(buildings: { id: building_id, zone_id: zone_id })
                  .where(room_tickets: { created_at: start_time..end_time })
                  .group('rooms.id')
                  .select('rooms.*, COUNT(room_tickets.id) AS tickets_count')
                  .having('COUNT(room_tickets.id) > 0')
                  .order('tickets_count DESC')

      if rooms.any?
        @title = 'Room Issues Report'
        @metrics = {
          'Total Tickets Count' => rooms.sum(&:tickets_count),
        }
        @headers = ['Room Number', 'Building', 'Zone', 'Tickets Count']
        @data = rooms.map do |room|
          [
            room.room_number,
            room.floor.building.name,
            show_zone(room.floor.building),
            room.tickets_count,
          ]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'room_issues_report.csv', type: 'text/csv' }
    end
  end

  def inspection_rate_report
    authorize :report, :inspection_rate_report?
    
    if params[:commit]
      zone_id, building_id, start_time, end_time = collect_form_params

      rooms = Room.active
                  .joins(floor: { building: :zone }).joins(:room_states)
                  .where(buildings: { id: building_id, zone_id: zone_id })
                  .where(room_states: { updated_at: start_time..end_time })
                  .group('rooms.id')
                  .select('rooms.*')
                  .select('COUNT(room_states.id) AS room_check_count')
                  .order('room_check_count DESC')

      rooms_no_room_state = Room.active
                                .left_outer_joins(:room_states)
                                .joins(floor: { building: :zone })
                                .where(buildings: { id: building_id, zone_id: zone_id })
                                .where(room_states: { id: nil })
                                .where.not(id: rooms.map(&:id))
                                .select('rooms.*')
                                .select('0 AS room_check_count')
                                .order('rooms.room_number')

      if rooms.any?
        oldest_record = rooms.min_by { |room| room.room_states.first.updated_at }
        oldest_record_date = oldest_record.room_states.first.updated_at
        start_time = oldest_record_date.to_date if oldest_record_date < start_time || start_time == Date.new(0)
        days = (end_time.to_date - start_time.to_date).to_i

        rooms = rooms + rooms_no_room_state

        @title = 'Inspection Rate Report'
        @metrics = {
          'Total room checks' => rooms.sum(&:room_check_count),
          'Time Range' => "#{start_time.strftime('%m/%d/%y')} - #{end_time.strftime('%m/%d/%y')} (#{days} days)",
        }
        @headers = ['Room Number', 'Building', 'Zone', '# Checks', 'Inspection Rate']
        @data = rooms.map do |room|
          [
            room.room_number,
            room.floor.building.name,
            show_zone(room.floor.building),
            room.room_check_count,
            "#{(room.room_check_count.to_f / days * 100).round(2)}%"
          ]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'inpection_rate_report.csv', type: 'text/csv' }
    end
  end

  def no_access_report
    authorize :report, :no_access_report?

    if params[:commit]
      zone_id, building_id, start_time, end_time = collect_form_params

      rooms = Room.active
                  .joins(floor: :building).joins(:room_states)
                  .where(buildings: { id: building_id, zone_id: zone_id })
                  .where(room_states: { updated_at: start_time..end_time })
                  .where(room_states: { is_accessed: false })
                  .group('rooms.id')
                  .select('rooms.*')
                  .select('COUNT(room_states.id) AS na_states_count')
                  .select('array_agg(room_states.updated_at) as na_states_dates')
                  .select('array_agg(room_states.no_access_reason) as na_states_reasons')
                  .having('COUNT(room_states.id) > 0')
                  .order('na_states_count DESC')

      if rooms.any?
        @title = 'No Access Report'
        @metrics = {
          'Total No Access Count' => rooms.sum(&:na_states_count)
        }
        @headers = ['Room Number', 'Building', 'Zone', 'No Access Count', 'Dates and Reasons for No Access (Most Recent 5)']
        @data = rooms.map do |room|
          [
            room.room_number,
            room.floor.building.name,
            show_zone(room.floor.building),
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
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'no_access_report.csv', type: 'text/csv' }
    end
  end

  def common_attribute_states_report
    authorize :report, :common_attribute_states_report?

    if params[:commit]
      zone_id, building_id, start_time, end_time = collect_form_params

      rooms = Room.active
                  .joins(floor: { building: :zone }).joins(room_states: { common_attribute_states: :common_attribute })
                  .where(buildings: { id: building_id, zone_id: zone_id })
                  .where(room_states: { updated_at: start_time..end_time })
                  .select('rooms.*')
                  .select('room_states.updated_at')
                  .select('common_attributes.description AS common_attribute_description')
                  .select('common_attributes.need_checkbox as need_checkbox')
                  .select('common_attribute_states.checkbox_value as checkbox_value')
                  .select('common_attribute_states.quantity_box_value as quantity_box_value')
                  .where('common_attributes.archived = FALSE')
                  .order('zones.name ASC, buildings.name ASC, rooms.room_number ASC')

      if rooms.any?
        @grouped = true
        @title = 'Common Attribute States Report'

        earliest_date = rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.min
        latest_date = rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.max
        header_start = start_time == Date.new(0) ? earliest_date : start_time
        header_end = end_time == Date::Infinity.new ? latest_date : end_time

        @date_headers = (header_start.to_date..header_end.to_date).to_a
        @headers = ['Zone', 'Building', 'Room'] + @date_headers

        grouped_rooms = rooms.group_by { |room| room.common_attribute_description }
        @data = grouped_rooms.transform_values do |room_group|
          room_group.each_with_object(Hash.new { |hash, key| hash[key] = {} }) do |room, pivot_table|
            key = [show_zone(room.floor.building), room.floor.building.name, room.room_number]
            value = room.need_checkbox ? (room.checkbox_value ? 'Yes' : 'No') : room.quantity_box_value
            pivot_table[key][room.updated_at.to_date] = value
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'common_attribute_states_report.csv', type: 'text/csv' }
    end
  end

  def specific_attribute_states_report
    authorize :report, :specific_attribute_states_report?

    if params[:commit]
      zone_id, building_id, start_time, end_time = collect_form_params

      rooms = Room.active
                  .joins(floor: { building: :zone }).joins(room_states: { specific_attribute_states: :specific_attribute })
                  .where(buildings: { id: building_id, zone_id: zone_id })
                  .where(room_states: { updated_at: start_time..end_time })
                  .select('rooms.*')
                  .select('specific_attributes.description AS specific_attribute_description')
                  .select('room_states.updated_at')
                  .select('specific_attributes.need_checkbox as need_checkbox')
                  .select('specific_attribute_states.checkbox_value as checkbox_value')
                  .select('specific_attribute_states.quantity_box_value as quantity_box_value')
                  .where('specific_attributes.archived = FALSE')
                  .order('zones.name ASC, buildings.name ASC, rooms.room_number ASC, specific_attributes.description ASC')

      if rooms.any?
        @grouped = true
        @title = 'Specific Attribute States Report'

        earliest_date = rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.min
        latest_date = rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.max
        header_start = start_time == Date.new(0) ? earliest_date : start_time
        header_end = end_time == Date::Infinity.new ? latest_date : end_time

        @date_headers = (header_start.to_date..header_end.to_date).to_a
        @headers = ['Specific Attribute'] + @date_headers

        grouped_rooms = rooms.group_by { |room| "#{show_zone(room.floor.building)} | #{room.floor.building.name} | #{room.room_number}" }
        @data = grouped_rooms.transform_values do |room_group|
          room_group.each_with_object(Hash.new { |hash, key| hash[key] = {} }) do |room, pivot_table|
            key = ["#{room.specific_attribute_description}"]
            value = room.need_checkbox ? (room.checkbox_value ? 'Yes' : 'No') : room.quantity_box_value
            pivot_table[key][room.updated_at.to_date] = value
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'specific_attribute_states_report.csv', type: 'text/csv' }
    end
  end

  def resource_states_report
    authorize :report, :resource_states_report?

    @resource_types = AppPreference.find_by(name: "resource_types").value.split(",").each(&:strip!)

    if params[:commit]
      zone_id, building_id, start_time, end_time = collect_form_params
      resource_type = params[:resource_type].presence

      rooms = Room.joins(floor: { building: :zone }).joins(room_states: { resource_states: :resource })
                  .where(buildings: { id: building_id, zone_id: zone_id })
                  .where(room_states: { updated_at: start_time..end_time })
                  .select('rooms.*')
                  .select('resources.name AS resource_name')
                  .select("resources.resource_type as resource_type")
                  .select('room_states.updated_at')
                  .select('resource_states.is_checked as check_value')
                  .where('resources.archived = FALSE')
                  .where("resources.resource_type ILIKE ?", "%#{resource_type}%") # need to do a manual query for this because of circular definition of resources
                  .order('zones.name ASC, buildings.name ASC, rooms.room_number ASC, resources.name ASC')

      if rooms.any?
        @grouped = true
        @title = 'Resource States Report'

        earliest_date = rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.min
        latest_date = rooms.flat_map { |room| room.room_states.pluck(:updated_at) }.max
        header_start = start_time == Date.new(0) ? earliest_date : start_time
        header_end = end_time == Date::Infinity.new ? latest_date : end_time

        @date_headers = (header_start.to_date..header_end.to_date).to_a
        @headers = ['Resource'] + @date_headers

        grouped_rooms = rooms.group_by { |room| "#{show_zone(room.floor.building)} | #{room.floor.building.name} | #{room.room_number}" }
        @data = grouped_rooms.transform_values do |room_group|
          room_group.each_with_object(Hash.new { |hash, key| hash[key] = {} }) do |room, pivot_table|
            key = ["#{room.resource_name} (#{room.resource_type})"]
            value = room.check_value ? 'Yes' : 'No'
            pivot_table[key][room.updated_at.to_date] = value
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: 'resource_states_report.csv', type: 'text/csv' }
    end
  end

  private

  def set_form_values
    @zones = Zone.all.order(:name).map { |z| [z.name, z.id] }
    @buildings = Building.active.where.not(zone: nil).map { |building| [building.zone_id, building.name, building.id] }
  end

  def collect_form_params
    zone_id = params[:zone_id].presence || Zone.all.pluck(:id).push(nil)
    building_id = params[:building_id].presence || Building.all.pluck(:id).push(nil)
    start_time = params[:from].present? ? Date.parse(params[:from]).beginning_of_day : DateTime.new(0)
    end_time = params[:to].present? ? Date.parse(params[:to]).end_of_day : DateTime::Infinity.new
    [zone_id, building_id, start_time, end_time]
  end

  def csv_data
    CSV.generate(headers: true) do |csv|
      next csv << ["No data found"] if !@data

      csv << [@title]
      csv << []
      @metrics && @metrics.each { |desc, value| csv << [desc, value] }

      if @grouped
        @data.each do |group, pivot_table|
          csv << []
          csv << [group]
          csv << @headers
          pivot_table.each { |keys, record| csv << keys + @date_headers.map { |date| record[date] } }
        end
      else
        csv << []
        csv << @headers
        @data.each { |row| csv << row }
      end
    end
  end
end
