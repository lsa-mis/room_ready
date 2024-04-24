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

  ################################################
  # add facility_id to classrooms and update instructional_seating_count
  # 
  auth_token = AuthTokenApi.new("classrooms")
  result = auth_token.get_auth_token
  if result['success']
    total_time = 0
    access_token = result['access_token']
  else
    puts "No access_token - #{result['error']}"
    exit
  end

  api = ClassroomApi.new(access_token)
  @debug = api.add_facility_id_to_classrooms
  if @debug
    puts "error updating rooms"
    exit
  end
  puts "facility_ids are added to rooms"

  # rooms without facility_id were deleted
  # delete floors and buildings if there are any empty
  # 
  Floor.where.missing(:rooms).delete_all
  Building.where.missing(:floors).delete_all
  
  puts "done"

end
