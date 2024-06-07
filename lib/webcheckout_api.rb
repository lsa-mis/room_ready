class WebcheckoutApi
  def initialize(host, userid, password)
    @host = host
    @user_id = userid
    @password = password
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
    response['payload']
  end

  def get_resources(oid)
    response = send_request(
      "#{@host}/rest/resource/search",
      { query: { and: { homeLocation: { _class: "resource", oid: oid } } }, properties: ["resourceType"] }
    )
    response['payload']
  end

  private
  def send_request(url, body = nil)
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = @session_token
    request.content_type = "application/json; charset=UTF-8"
    request.body = body.to_json if body

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    response_body = JSON.parse(response.body)
    if response_body['status'] == 'ok'
      response_body
    else
      raise StandardError, "API request to Webcheckout failed with status [#{response_body['status']}]: #{response_body['payload']['message']}"
    end
  end
end
