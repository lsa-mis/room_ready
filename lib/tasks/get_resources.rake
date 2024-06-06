desc "This will write resources to resources.txt from the webcheckout api"
task get_resources: :environment do
  location_oids = File.open(Rails.root.join('webcheckout_api/files/locations_oids.txt'), "rb") do |f|
    f.read
  end

  location_oids = location_oids.split(" ").map(&:to_i)

  api = WebcheckoutApi.new

  api.start_session

  location_oids.each do |oid|
    puts oid
    payload = api.get_resources(oid)
    if payload['count'] > 0
      File.open(Rails.root.join('webcheckout_api/files/resources.txt'), 'a') do |file|
        payload['result'].each do |resource|
          file.write("#{oid};;#{resource['name']};;#{resource['resourceType']['name']}\n")
        end
      end
    end
  end

  api.end_session
end
