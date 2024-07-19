desc "This will add Central Campus classrooms to the empty database"
task add_rooms: :environment do

  #################################################
  # get access token
  #
  auth_token = AuthTokenApi.new("buildings")
  # auth_token "expires_in":3600 seconds
  result = auth_token.get_auth_token

  if result['success']
    access_token = result['access_token']
    puts "success"
  else
    puts "No access_token - #{result['error']}"
    exit
  end
  @debug = false
  #################################################
  # update buildings
  #
  api = BuildingsApi.new(access_token)
  @debug = api.update_all_buildings

  if @debug
    puts "error updating buildings"
    exit
  end
  puts "buildings added"

  #################################################
  # update rooms
  #
  @debug = api.update_rooms
  if @debug
    puts "error updating rooms"
    exit
  end
  puts "rooms added"

  ###############################################
  # delete buildings without rooms
  # 
  Building.where.missing(:floors).delete_all
  puts "buildings without classrooms deleted"

  # delete floors and buildings if there are any empty
  # 
  Floor.where.missing(:rooms).delete_all
  Building.where.missing(:floors).delete_all
  
  puts "done"

end
