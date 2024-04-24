desc "This will write rooms_to_update rmrecnbr to a rooms_to_update.txt file"
task write_resources_to_db: :environment do
  require 'pry'
  # types of resourses to add to the database
  type_names = ['Wireless Bodypack Transmitter', 
                "Instructional PC Desktop",
                "Blu-Ray Player",
                "Lecture Capture Camera",
                "Video Projector"]
  # all rooms in the database
  rooms_to_update = Room.all.pluck(:rmrecnbr)
  # hash of rooms in db => oid in wco
  room_location = {}
  File.open(Rails.root.join('webcheckout_api/files/room_location.txt'), "rb") do |f|
    f.each_line do |line|
      l = line.split(" ")
      room_location[l[1]] = l[0]
    end
  end

  # array of [oid, resource_name, resource_type] - output from node script create_resorces.js
  wco_resources = []
  File.readlines(Rails.root.join('webcheckout_api/files/resources.txt'), chomp: true).each do |line|
    l = line.split(";;")
    wco_resources.push(l)
  end

  # convert wco_resources to hash of arrays: array of resources for every room
  wco_resources_sorted = wco_resources.sort_by{ |r| r.first }
  resources = {}
  wco_resources_sorted.group_by(&:first).map { |a, b| resources[a] = b.map { |c| c.drop(1) }}

  # sync resources form wco with resources in db
  resources.each do |oid, room_resources|
    room_rmrecnbr = room_location[oid]
    room = Room.find_by(rmrecnbr: room_rmrecnbr)
    if room.present?
      # hash of resources for the room that exist in db {name => id}
      resources_in_db = room.resources.map { |r| room_resources[r.name] = r.id }
      room_resources.each do |resource_name, resource_type|
        if Resource.find_by(room_id: room.id, name: resource_name).present?
          # wco resource exist in db, delete from array
          resources_in_db.delete(resource_name)
        else
          # create a wco resource that was not present in db
          if type_names.include?(resource_type)
            Resource.create(room_id: room.id, name: resource_name, resource_type: resource_type)
          end
        end
      end
      if resources_in_db.present?
        # these resoursces are not present in sco any more - delete from db
        Resource.where(id: room_resources.values).delete_all
      end
      # room updated by wco - delete from list
      rooms_to_update.delete(room_rmrecnbr)
    end
  end

  if rooms_to_update.present?
    # these rooms were not updated because they don't eexist in wco
    list = rooms_to_update.map { |room| Room.find_by(rmrecnbr: room).facility_id }.join(", ")
    note = "The following rooms don't exist in WebCheCkout database: " + list
    RoomUpdateLog.create(date: Date.today, note: note)
  end 
end
