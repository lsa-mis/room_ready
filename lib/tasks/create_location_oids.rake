desc "This will write location_oids to location_oids.txt from the webcheckout api"
task create_location_oids: :environment do
  rooms = File.open(Rails.root.join('webcheckout_api/files/room_rmrecnbr.txt'), "rb") do |f|
    f.read
  end

  rooms = rooms.split(" ")

  api = WebcheckoutApi.new

  api.start_session

  payload = api.get_location_oids(rooms)

  location_oids = payload['result'].map { |item| item['oid'] }.join(' ')
  room_location_data = payload['result'].map { |item| "#{item['barcode']} #{item['oid']}" }.join("\n")

  File.open(Rails.root.join('webcheckout_api/files/locations_oids.txt'), 'w') {|file| file.write(location_oids) }
  File.open(Rails.root.join('webcheckout_api/files/room_location.txt'), 'w') {|file| file.write(room_location_data) }

  api.end_session
end
