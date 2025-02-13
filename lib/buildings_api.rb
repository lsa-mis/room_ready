class BuildingsApi

  def initialize(access_token)
    @access_token = access_token
    @debug = false
  end

  # update buildings

  def update_all_buildings
    begin
      result = get_buildings_for_current_fiscal_year
      if result['success']
        data = result['data']
        data.each do |row|
          if row['BuildingCampusCode'] == "100"
            create_building(row)
            return @debug if @debug
          end
        end
      else
        puts "update_all_buildings, error: API return: #{result['errorcode']} - #{result['error']}"
        @debug = true
        return @debug
      end
    rescue StandardError => e
      # example: Errno::ETIMEDOUT: Operation timed out - user specified timeout
      @log.api_logger.debug "update_all_buildings, error: #{e.message}"
      @debug = true
    end
    return @debug
  end

  def create_building(row)
    bldrecnbr = row['BuildingRecordNumber'].to_i
    address = " #{row['BuildingStreetNumber']}  #{row['BuildingStreetDirection']}  #{row['BuildingStreetName']}".strip.gsub(/\s+/, " ")
    building = Building.new(bldrecnbr: bldrecnbr, name: row['BuildingLongDescription'].titleize, 
        address: address.titleize, 
        city: row['BuildingCity'].titleize, state: row['BuildingState'], zip: row['BuildingPostal'])
    unless building.save
      puts "update_all_buildings, error: Could not create #{bldrecnbr} because : #{building.errors.messages}"
      @debug = true
    end
    return @debug
  end

  def get_buildings_for_current_fiscal_year
    begin
      result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
      buildings = []
      start_index = 0
      count = 1000
      next_page = true
      while next_page do
        url = URI("https://gw.api.it.umich.edu/um/bf/Buildings/v2/BuildingInfo?$start_index=#{start_index}&$count=#{count}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        request = Net::HTTP::Get.new(url)
        request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
        request["authorization"] = "Bearer #{@access_token}"
        request["accept"] = 'application/json'

        response = http.request(request)
        response_json = JSON.parse(response.read_body)
        link = response.to_hash["link"].to_s
        if link.include? "rel=next"
          start_index += count
        else
          next_page = false
        end
        if response.code == "200"
          result['success'] = true
          buildings += response_json['ListOfBldgs']['Buildings']
        elsif response_json['errorCode'].present?
          @result['errorcode'] = response_json['errorCode']
          @result['error'] = response_json['errorMessage']
        else 
          @result['errorcode'] = "Unknown error"
        end
      end
      result['data'] = buildings
    rescue StandardError => e
      @result['errorcode'] = "Exception"
      @result['error'] = e.message
    end
    return result
  end

  # update rooms for every building

  def update_rooms
    begin
      buildings = Building.all.pluck(:id, :bldrecnbr)
      number_of_api_calls_per_minutes = 0
      buildings.each do |bld|
        result = get_building_classroom_data(bld[1])
        if result['success']
          if result['data'].present?
            data = result['data']
            if data.present?
              # check data for buildings that have rooms with RoomTypeDescription == "Classroom"
              if data.pluck("RoomTypeDescription").uniq.include?("Classroom")
                data.each do |row|
                  # update only Classrooms not all rooms
                  if row['RoomTypeDescription'] == "Classroom"
                    create_room(row, bld[0])
                    # if create_room returns true (@debug)
                    return @debug if @debug
                  end
                end
              end
            end
          end
        else
          puts "update_rooms, error: API return: #{result['errorcode']} - #{result['error']}"
          @debug = true
          return @debug
        end
      end
    rescue StandardError => e
      # example: Errno::ETIMEDOUT: Operation timed out - user specified timeout
      puts "update_rooms, error: #{e.message}"
      @debug = true
    end
    return @debug
  end

  def create_room(row, building_id)
    rmrecnbr = row['RoomRecordNumber'].to_i
    unless Floor.find_by(building_id: building_id, name: row['FloorNumber']).present?
      floor = Floor.new(building_id: building_id, name: row['FloorNumber'])
      unless floor.save
        puts "update_rooms, error: Could not create floor for #{building_id} building because : #{floor.errors.messages}"
        @debug = true
        return @debug
      end
    end
    floor = Floor.find_by(building_id: building_id, name: row['FloorNumber'])
    room = Room.new(floor_id: floor.id, rmrecnbr: rmrecnbr, room_number: row['RoomNumber'], 
          room_type: row['RoomTypeDescription'])
    unless room.save
      puts "update_rooms, error: Could not create #{rmrecnbr} because : #{room.errors.messages}"
      @debug = true
      return @debug
    end
      return @debug
  end

  def get_building_classroom_data(bldrecnbr)
    begin
      result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
      rooms = []
      start_index = 0
      count = 1000
      next_page = true
      while next_page do

        url = URI("https://gw.api.it.umich.edu/um/bf/Buildings/v2/RoomInfo/#{bldrecnbr}?$start_index=#{start_index}&$count=#{count}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        request = Net::HTTP::Get.new(url)
        request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
        request["authorization"] = "Bearer #{@access_token}"
        request["accept"] = 'application/json'

        response = http.request(request)
        link = response.to_hash["link"].to_s
        if link.include? "rel=next"
          start_index += count
        else
          next_page = false
        end
        response_json = JSON.parse(response.read_body)
        if response.code == "200"
          result['success'] = true
          if response_json['ListOfRooms'].present?
            data = response_json['ListOfRooms']['RoomData']
            rooms += data
          end
        elsif response_json['errorCode'].present?
          @result['errorcode'] = response_json['errorCode']
          @result['error'] = response_json['errorMessage']
        else 
          @result['errorcode'] = "Unknown error"
        end
      end
      result['data'] = rooms
    rescue StandardError => e
      @result['errorcode'] = "Exception"
      @result['error'] = e.message
    end
    return result
  end
end
