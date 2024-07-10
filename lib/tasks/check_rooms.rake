desc "Automatically check all rooms that have not been checked today."
task check_rooms: :environment do
  rooms = get_all_unchecked_rooms
  puts rooms.first.id
  rooms.each do |room|  
    check_room(room)
  end
end

def get_all_unchecked_rooms
  all_unchecked_rooms = []
  zones = Zone.all
  zones.each do |zone|
    zone.buildings.each do |building|
      building.floors.each do |floor|
        floor.rooms.each do |room|
          room_status = RoomStatus.new(room)
          unless room_status.room_checked_once?
            all_unchecked_rooms << room
            next
          end

          unless room_status.room_checked_today?
            all_unchecked_rooms << room
          end
        end
      end
    end
  end
  all_unchecked_rooms
end

def check_room(room)
  @common_attributes = CommonAttribute.active 
  @specific_attributes = SpecificAttribute.where(room_id: room.id)
  @resources = Resource.where(room_id: room.id)
  @random_bool_list = [true, true, true, false]

  check_room_state(room)

  if @common_attributes.present?
    check_common_attribute_state(room)
  end

  if @specific_attributes.present?
    check_specific_attribute_state(room)
  end

  if @resources.present?  
    check_resource_state(room)
  end
end

def check_room_state(room)
  @room_state = RoomState.new(generate_room_state_params(room))
  if @room_state.save
    room.update(last_time_checked: DateTime.now)
    puts "Room state created for room #{room.id}"
  end
  @room_state
end

def check_common_attribute_state(room)
  generate_common_attribute_state_params.each do |cas|
    common_attribute_state = CommonAttributeState.new(cas)
    if common_attribute_state.save
      puts "Common attribute state created for room state #{@room_state.id}"
    end
  end
end

def check_specific_attribute_state(room)
  generate_specific_attribute_state_params.each do |sas|
    specific_attribute_state = SpecificAttributeState.new(sas)
    if specific_attribute_state.save
      puts "Specific attribute state created for room state #{@room_state.id}"
    end
  end
end

def check_resource_state(room)
  generate_resource_state_params.each do |rs|
    resource_state = ResourceState.new(rs)
    if resource_state.save
      puts "Resource state created for room state #{@room_state.id}"
    end
  end
end

def generate_room_state_params(room)
  room_state_params = {
    room_id: room.id,
    checked_by: "AUTOMATED SCRIPT",
    is_accessed: nil,
    report_to_supervisor: nil,
    no_access_reason: nil,
  }

  room_state_params[:is_accessed] = @random_bool_list.sample
  room_state_params[:report_to_supervisor] = !@random_bool_list.sample

  if room_state_params[:is_accessed] == false
    no_access_reasons = AppPreference.find_by(name: 'no_access_reason')&.value&.split(',').map(&:strip)
    room_state_params[:no_access_reason] = no_access_reasons.sample
  end

  room_state_params
end

def generate_common_attribute_state_params
  common_attribute_states = []
  @common_attributes.each do |common_attribute|
    common_attribute_state_params = {
      common_attribute_id: common_attribute.id,
      room_state_id: @room_state.id,
      checkbox_value: @random_bool_list.sample,
    }
    common_attribute_states << common_attribute_state_params
  end
  common_attribute_states
end

def generate_specific_attribute_state_params
  specific_attribute_states = []
  @specific_attributes.each do |specific_attribute|
    specific_attribute_state_params = {
      specific_attribute_id: specific_attribute.id,
      room_state_id: @room_state.id,
      checkbox_value: nil,
      quantity_box_value: nil,
    }

    if specific_attribute.need_checkbox
      specific_attribute_state_params[:checkbox_value] = @random_bool_list.sample
    end

    if specific_attribute.need_quantity_box
      specific_attribute_state_params[:quantity_box_value] = rand(1..10)
    end

    specific_attribute_states << specific_attribute_state_params
  end
  specific_attribute_states
end

def generate_resource_state_params
  resource_states = []
  @resources.each do |resource|
    resource_state_params = {
      resource_id: resource.id,
      room_state_id: @room_state.id,
      is_checked: @random_bool_list.sample,
    }
    resource_states << resource_state_params
  end
  resource_states
end