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
