class ClassroomApi

  def initialize(access_token)
    @buildings_ids = Building.all.pluck(:bldrecnbr)
    @access_token = access_token
    @debug = false
    @log = ApiLog.new
  end

  def add_facility_id_to_classrooms
    @rooms_in_db = Room.all.pluck(:rmrecnbr)
    result = get_classrooms_list
    if result['success']
      classrooms_list = result['data'] 
      number_of_api_calls_per_minutes = 0
      redo_loop_number = 1
      classrooms_list.each do |room|
        # update only rooms for campuses and buildings from the MClassroom database
        if @buildings_ids.include?(room['BuildingID'])
          if number_of_api_calls_per_minutes < 400
            number_of_api_calls_per_minutes += 1
          else
            puts "add_facility_id_to_classrooms, the script sleeps after #{number_of_api_calls_per_minutes} calls"
            number_of_api_calls_per_minutes = 1
            sleep(61.seconds)
          end
          facility_id = room['FacilityID'].to_s
          # add facility_id and number of seats
          result = get_classroom_info(ERB::Util.url_encode(facility_id))
          if result['errorcode'] == "ERR429"
            puts "add_facility_id_to_classrooms, error: API return: #{result['errorcode']} - #{result['error']} after #{number_of_api_calls_per_minutes} calls"
            number_of_api_calls_per_minutes = 0
            sleep(61.seconds)
            if redo_loop_number > 9
              @debug = true
             puts "add_facility_id_to_classrooms, error: API return: #{result['errorcode']} - #{result['error']} after #{number_of_api_calls_per_minutes} calls #{redo_loop_number} times "
              return @debug
            end
            redo_loop_number += 1
            redo
          elsif result['success']
            room_info = result['data'][0]
            rmrecnbr = room_info['RmRecNbr']
            room_in_db = Room.find_by(rmrecnbr: rmrecnbr)
            if room_in_db
              if room_in_db.update(facility_id: facility_id)
                @rooms_in_db.delete(rmrecnbr)
              else
                puts "add_facility_id_to_classrooms, error: Could not update: rmrecnbr - #{rmrecnbr}, facility_id - #{facility_id}"
                @debug = true
                return @debug
              end
            end
          else
            puts "add_facility_id_to_classrooms, error: API return: #{result['errorcode']} - #{result['error']} for #{facility_id}"
            @debug = true
            return @debug
          end
        end
      end
    else
      puts "add_facility_id_to_classrooms, error: API return: #{result['errorcode']} - #{result['error']} for #{facility_id}"
      @debug = true
      return @debug
    end
    # check if database has rooms that are not in API anymore
    if @rooms_in_db.present?
      if Room.where(rmrecnbr: @rooms_in_db).delete_all
        puts "add_facility_id_to_classrooms, delete #{@rooms_in_db} room(s) from the database"
      else
        puts "add_facility_id_to_classrooms, error: could not delete records with #{@rooms_in_db} rmrecnbr"
        @debug = true
        return @debug
      end
    end
    return @debug
  end

  def get_classrooms_list
    result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
    url = URI("https://gw.api.it.umich.edu/um/aa/ClassroomList/Classrooms?BuildingID=1005046")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
    request["authorization"] = "Bearer #{@access_token}"
    request["accept"] = 'application/json'

    response = http.request(request)
    response_json = JSON.parse(response.read_body)
    if response_json['errorCode'].present?
      result['errorcode'] = response_json['errorCode']
      result['error'] = response_json['errorMessage']
    else
      result['success'] = true
      result['data'] = response_json['Classrooms']['Classroom']
    end
    return result
    
  end

  def get_classroom_info(facility_id)
    result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
    @debug = false
    
    url = URI("https://gw.api.it.umich.edu/um/aa/ClassroomList/Classrooms/#{facility_id}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
    request["authorization"] = "Bearer #{@access_token}"
    request["accept"] = 'application/json'

    response = http.request(request)
    response_json = JSON.parse(response.read_body)
    if response_json.present?
      if response_json['errorCode'].present?
        result['errorcode'] = response_json['errorCode']
        result['error'] = response_json['errorMessage']
        result['success'] = false
      else
        result['success'] = true
        result['data'] = response_json['Classrooms']['Classroom']
      end
    end
    return result
  end
end
