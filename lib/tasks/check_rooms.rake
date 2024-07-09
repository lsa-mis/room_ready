desc "Print all active rooms"
task check_rooms: :environment do
  rooms = get_all_unchecked_rooms

  puts rooms.count

  
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
  common_attributes = CommonAttribute.active 
  specific_attributes = SpecificAttribute.where(room_id: room.id)
  resources = Resource.where(room_id: room.id)
end

def check_room_state(room)
  
end

def check_common_attribute_state(room)

end

def check_specific_attribute_state(room)

end

def check_resource_state(room)

end