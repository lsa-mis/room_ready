class WebcheckoutApi
  def initialize(scope)
    @scope = scope
    @returned_data = {'success' => false, 'error' => '', 'access_token' => nil}
    @user_id = ENV['WCO_USER_ID']
    @password = ENV['WCO_PASSWORD']
    @host = ENV['WCO_HOST']
    @session_token = 'Bearer Requested'
  end

  def start_session
    response = send_request("#{@host}/rest/session/start", { userid: @user_id, password: @password })
    @session_token = "Bearer #{response['sessionToken']}"
  end

  def end_session
    response = send_request("#{@host}/rest/session/logout")
  end

  def get_location_oids(rooms)
    response = send_request("#{@host}/rest/resource/search", { query: { barcode: rooms }})
    # TODO
  end

  def get_resources
    # TODO
  end

  private
  def send_request(url, body = nil)
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = @session_token
    request.content_type = "application/json; charset=UTF-8"
    p body.to_json
    request.body = body.to_json if body

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
