desc "This will write rooms rmrecnbr to a rooms.txt file"
task write_rooms_to_file: :environment do

  rooms = Room.all.pluck(:rmrecnbr).join(' ')
  File.open(Rails.root.join('webcheckout_api/files/room_rmrecnbr.txt'), 'w') { |file| file.write(rooms) }
 
end