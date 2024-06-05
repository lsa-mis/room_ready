module BuildingApi
  require 'uri'
  require 'net/http'

  def get_building_info_by_bldrecnbr(bldrecnbr)
    begin
      token = get_auth_token("buildings")
      if token['success']
        result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
        url = URI("https://gw.api.it.umich.edu/um/bf/Buildings/v2/BuildingInfoById/#{bldrecnbr}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
        request["authorization"] = "Bearer #{token['access_token']}"
        request["accept"] = 'application/json'

        response = http.request(request)
        response_json = JSON.parse(response.read_body)
        if response.code == "200"
          result['success'] = true
          result['data'] = response_json['ListOfBldgs']['Buildings']
        elsif response_json['errorCode'].present?
          result['errorcode'] = response_json['errorCode']
          result['error'] = response_json['errorMessage']
        else 
          result['errorcode'] = "Unknown error"
        end
      else
      end
      rescue StandardError => e
        result['errorcode'] = "Exception"
        result['error'] = e.message
    end
    return result
  end

  def get_classrooms_for_building(bldrecnbr)
    begin
      token = get_auth_token("buildings")
      if token['success']
        result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
        rooms = []
        start_index = 0
        count = 1000
        next_page = true
        while next_page do

          url = URI("https://gw.api.it.umich.edu/um/bf/Buildings/v2/RoomInfo/#{bldrecnbr}?$start_index=#{start_index}&$count=#{count}")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Get.new(url)
          request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
          request["authorization"] = "Bearer #{token['access_token']}"
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
            result['errorcode'] = response_json['errorCode']
            result['error'] = response_json['errorMessage']
          else 
            result['errorcode'] = "Unknown error"
          end
        end
      else
      end
      result['data'] = rooms
    rescue StandardError => e
        result['errorcode'] = "Exception"
        result['error'] = e.message
    end
    return result
  end

  def get_room_info_by_rmrecnbr(bldrecnbr, rmrecnbr)
    begin
      token = get_auth_token("buildings")
      if token['success']
        result = {'success' => false, 'errorcode' => '', 'error' => '', 'data' => {}}
        start_index = 0
        count = 1000
        next_page = true
        while next_page do

          url = URI("https://gw.api.it.umich.edu/um/bf/Buildings/v2/RoomInfo/#{bldrecnbr}?$start_index=#{start_index}&$count=#{count}")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Get.new(url)
          request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:buildings_client_id]}"
          request["authorization"] = "Bearer #{token['access_token']}"
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
              response_json['ListOfRooms']['RoomData'].each do |room|
                if room["RoomRecordNumber"] == rmrecnbr
                  result['data'] = room
                  return result
                end
              end
            end
          elsif response_json['errorCode'].present?
            result['errorcode'] = response_json['errorCode']
            result['error'] = response_json['errorMessage']
          else 
            result['errorcode'] = "Unknown error"
          end
        end
      else
      end
    rescue StandardError => e
      result['errorcode'] = "Exception"
      result['error'] = e.message
    end
    unless result['data'].present?
      result['success'] = false
      result['error'] = "Room record number " + rmrecnbr + " is not valid. "
    end
    return result
  end

  def get_auth_token(scope)
    returned_data = {'success' => false, "error" => "", 'access_token' => nil}
    url = URI("https://gw.api.it.umich.edu/um/oauth2/token")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["accept"] = 'application/json'
    request.body = "grant_type=client_credentials&client_id=#{Rails.application.credentials.um_api[:client_id]}&client_secret=#{Rails.application.credentials.um_api[:client_secret]}&scope=#{scope}"

    response = http.request(request)
    response_json = JSON.parse(response.read_body)
    if response_json['access_token'].present?
      returned_data['success'] = true
      returned_data['access_token'] = response_json['access_token']
    else
      returned_data['error'] = response_json
    end
    return returned_data
  end

end
