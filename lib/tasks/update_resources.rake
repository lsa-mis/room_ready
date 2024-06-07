desc "This task will update resources in the database from the webcheckout api"
task update_resources: :environment do
  host = "https://webcheckout.lsa.umich.edu"
  userid = Rails.application.credentials.dig(:webcheckout_api, :userid)
  password = Rails.application.credentials.dig(:webcheckout_api, :password)

  begin
    rooms = Room.all.pluck(:rmrecnbr)

    #=============================
    #   get oids from api        #
    #=============================
    api = WebcheckoutApi.new(host, userid, password)
    api.start_session
    payload = api.get_location_oids(rooms)
    location_oids = payload['result'].map { |item| item['oid'].to_i }
    room_location = payload['result'].map { |item| [item['oid'], item['barcode']] }.to_h
    api.end_session

    #=============================
    #   get resources from api   #
    #=============================
    api = WebcheckoutApi.new(host, userid, password)
    api.start_session
    wco_resources = []
    location_oids.each do |oid|
      payload = api.get_resources(oid)
      if payload['count'] > 0
        payload['result'].each do |resource|
          wco_resources.push([oid, resource['name'], resource['resourceType']['name']])
        end
      end
    end
    api.end_session

    #=============================
    #   update the database      #
    #=============================
    type_names = ['Wireless Bodypack Transmitter',
                  "Instructional PC Desktop",
                  "Blu-Ray Player",
                  "Lecture Capture Camera",
                  "Video Projector"]

    rooms_to_update = Room.all.pluck(:rmrecnbr)

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
        resources_in_db = room.resources.pluck(:name, :id).to_h

        room_resources.each do |resource_name, resource_type|
          if resources_in_db.key?(resource_name)
            # wco resource exist in db, delete from array
            resources_in_db.delete(resource_name)
          else
            # create a wco resource that was not present in db
            if type_names.include?(resource_type)
              room.resources.create(name: resource_name, resource_type: resource_type)
            end
          end
        end
        if resources_in_db.present?
          # these resoursces are not present in sco any more - delete from db
          room.resources.find(resources_in_db.values).delete_all
        end
        # room updated by wco - delete from list
        rooms_to_update.delete(room_rmrecnbr)
      end
    end

    if rooms_to_update.present?
      # these rooms were not updated because they don't eexist in wco
      list = Room.where(rmrecnbr: rooms_to_update).pluck(:rmrecnbr).join(", ")
      note = "Resources updated successfully for rooms. The following rooms don't exist in WebCheckout database: " + list
      RoomUpdateLog.create(date: Date.today, note: note)
    else
      RoomUpdateLog.create(date: Date.today, note: "Resources updated successfully for all rooms")
    end
  rescue StandardError => e
    RoomUpdateLog.create(date: Date.today, note: e)
  end
end
