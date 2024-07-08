require 'rails_helper'

RSpec.describe Room, type: :system do

  before do
    user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    mock_login(user)
  end

	context 'create a new room with invalid rmrecnbr' do
    let!(:building) { FactoryBot.create(:building) }

    it 'returns "rmrecnbr is invalid" message' do
      VCR.use_cassette "room" do
        rmrecnbr = '1234567'
        result = {"success"=>false, "errorcode"=>"", "error"=>"Room record number 123456 is not valid. ", "data"=>{}}
        allow_any_instance_of(BuildingApi).to receive(:get_room_info_by_rmrecnbr).with(building.bldrecnbr, rmrecnbr).and_return(result)
        visit "rooms/new?building_id=#{building.id}"
        fill_in "Room Record Number", with: rmrecnbr
        click_on "Create Room"
        expect(page).to have_content("is not valid.")
        expect(Room.find_by(rmrecnbr: rmrecnbr).present?).to be_falsy
      end
    end
  end

  context 'create a new room with valid bldrecnbr' do
    let!(:building) { FactoryBot.create(:building) }
    it 'returns "New Room was added" message' do
      VCR.use_cassette "room" do
        rmrecnbr = '1234567'
        result = {"success"=>true, "errorcode"=>"Exception", "error"=>"", 
          "data"=>{"RoomRecordNumber"=>"1234567", "RoomNumber"=>"102", "FloorNumber"=>"01", 
          "RoomSquareFeet"=>252, "RoomStationCount"=>8, "DepartmentName"=>"MM Ctr for History of Medicine", 
          "RoomTypeDescription"=>"Open Stack Study Room", "RoomTypeGroupDescription"=>"Study Facilities", 
          "RoomSubTypeDescription"=>"Departmental"}}
        allow_any_instance_of(BuildingApi).to receive(:get_room_info_by_rmrecnbr).with(building.bldrecnbr, rmrecnbr).and_return(result)
        visit "rooms/new?building_id=#{building.id}"
        fill_in "Room Record Number", with: rmrecnbr
        click_on "Create Room"
        expect(page).to have_content("Room was successfully added")
        expect(Room.find_by(rmrecnbr: rmrecnbr).present?).to be_truthy
      end
    end
  end

  context 'archive a room' do
    let!(:room) { FactoryBot.create(:room) }
    let!(:room_state) { FactoryBot.create(:room_state, room: room) }
    it 'shows a message that room was archived' do
      VCR.use_cassette "room" do
        room_id = room.id
        visit "rooms/#{room_id}"
        accept_confirm 'Are you sure you want to archive this room?' do
          find(:css, 'i.bi.bi-archive-fill.text-success').click
        end
        expect(page).to have_content("The room was archived")
        expect(Room.find(room_id).archived == true).to be_truthy
      end
    end
  end

  context 'cancel archiving a room' do
    let!(:room) { FactoryBot.create(:room) }
    let!(:room_state) { FactoryBot.create(:room_state, room: room) }
    it 'do not shows a message that room was archived' do
      VCR.use_cassette "room" do
        visit "rooms/#{room.id}"
        dismiss_confirm 'Are you sure you want to archive this room?' do
          find(:css, 'i.bi.bi-archive-fill.text-success').click
        end
        expect(page).to_not have_content("The room was archived")
        expect(room.archived == false).to be_truthy
      end
    end
  end

  context 'delete a room' do
    let!(:room) { FactoryBot.create(:room) }

    it 'shows that room can not be find in the database' do
      VCR.use_cassette "room" do
        room_id = room.id
        visit "rooms/#{room_id}"
        accept_confirm 'Are you sure you want to delete this room?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("The room was deleted")
        expect { Room.find(room_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'cancel deleting a room' do
    let!(:room) { FactoryBot.create(:room) }

    it 'shows that room still exists in the database' do
      VCR.use_cassette "room" do
        room_id = room.id
        visit "rooms/#{room_id}"
        dismiss_confirm 'Are you sure you want to delete this room?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(Room.find(room_id).present?).to be_truthy
      end
    end
  end

end
