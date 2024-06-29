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
        sleep 3
        expect(page).to have_content("Room was successfully added")
      end
    end
  end

end
