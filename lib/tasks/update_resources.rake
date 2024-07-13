desc "This task will update resources in the database from the webcheckout api"
task update_resources: :environment do
  host = "https://webcheckout.lsa.umich.edu"
  userid = Rails.application.credentials.dig(:webcheckout_api, :userid)
  password = Rails.application.credentials.dig(:webcheckout_api, :password)

  type_names = AppPreference.find_by(name: "resource_types").value.split(",").each(&:strip!)
  if type_names.empty?
    RoomUpdateLog.create(date: Date.today, note: "No resource_types defined in app preferences. Task was not run.")
    next # skips the task
  end

  begin
    rooms = Room.active.pluck(:rmrecnbr)

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
    wco_resources = location_oids.flat_map do |oid|
      payload = api.get_resources(oid)
      if payload['count'] > 0
        payload['result'].map { |resource| [oid, resource['name'], resource['resourceType']['name']] }
      else
        []
      end
    end
    api.end_session

    #=============================
    #   update the database      #
    #=============================
    rooms_to_update = Room.active.pluck(:rmrecnbr)

    # convert wco_resources to hash of arrays: array of resources for every room
    resources = wco_resources
                  .sort_by(&:first)
                  .group_by(&:first)
                  .transform_values { |group| group.map { |resource| resource[1..-1] } }

    transaction_error = nil
    transaction_succeeded = ActiveRecord::Base.transaction do
      begin
        rooms_to_update = update_resources_in_db(resources, room_location, type_names, rooms_to_update)
      rescue StandardError => e
        transaction_error = e
        raise ActiveRecord::Rollback # Manually rollback the transaction
      end
    end

    raise "Transaction failed, error updating resources: #{transaction_error}" unless transaction_succeeded

    if rooms_to_update.any?
      # these rooms were not updated because they don't eexist in wco
      list = Room.where(rmrecnbr: rooms_to_update).map { |r| r.floor.building.nick_name.present? ? [r.floor.building.nick_name, r.room_number].join(' ') : [r.floor.building.name,  r.room_number].join(' ')  }
      note = "Resources updated successfully for rooms. The following rooms don't exist in WebCheckout database: #{list}"
      RoomUpdateLog.create(date: Date.today, note: "success-partial | #{note}")
    else
      RoomUpdateLog.create(date: Date.today, note: "success | Resources updated successfully for all rooms")
    end
  rescue StandardError => e
    RoomUpdateLog.create(date: Date.today, note: "error | #{e}")
  end
end

def update_resources_in_db(resources, room_location, type_names, rooms_to_update)
  # sync resources form wco with resources in db
  resources.each do |oid, room_resources|
    room_rmrecnbr = room_location[oid]
    room = Room.find_by(rmrecnbr: room_rmrecnbr)
    if room.present?
      # hashes of resources for the room that exist in db {name => id}
      active_resources_in_db = room.active_resources.pluck(:name, :id).to_h
      archived_resources_in_db = room.archived_resources.pluck(:name, :id).to_h

      room_resources.each do |resource_name, resource_type|
        next unless type_names.include?(resource_type)

        if active_resources_in_db.key?(resource_name)
          # wco resource exist in db, delete from array
          active_resources_in_db.delete(resource_name)
        elsif archived_resources_in_db.key?(resource_name)
          # wco resource is archived in db, so unarchive it
          id = archived_resources_in_db[resource_name]
          room.resources.find(id).update(archived: false)
        else
          # create a wco resource that was not present in db
          room.resources.create(name: resource_name, resource_type: resource_type)
        end
      end

      active_resources_in_db.each do |_, id|
        # these resoursces are not present in sco any more, so archive or delete appropriately
        resource = room.resources.find(id)
        if resource.resource_states.any?
          resource.update(archived: true)
        else
          resource.destroy
        end
      end

      # room updated by wco - delete from list
      rooms_to_update.delete(room_rmrecnbr)
    end
  end
  rooms_to_update
end
