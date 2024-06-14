require 'rails_helper'

RSpec.describe Building, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    mock_login(user)
  end

	context 'create a new building with invalid bldrecnbr' do
    it 'returns "bldrecnbr is invalid" message' do
      VCR.use_cassette "building" do
        bldrecnbr = '1234567'
        result = {"success"=>false, "errorcode"=>"", "error"=>"Building record number 123456 is not valid. ", "data"=>{}}
        allow_any_instance_of(BuildingApi).to receive(:get_building_info_by_bldrecnbr).with(bldrecnbr).and_return(result)
        visit new_building_path
        fill_in "Building Record Number", with: "1234567"
        click_on "Create Building"
        expect(page).to have_content("is not valid.")
      end
    end
  end

  context 'create a new building valid bldrecnbr' do
    it 'returns "bldrecnbr is invalid" message' do
      VCR.use_cassette "building" do
        bldrecnbr = '1234567'
        result = {"success"=>true, "errorcode"=>"", "error"=>"", 
          "data"=>[{"FiscalYear"=>2024, "BuildingRecordNumber"=>"1234567", "BuildingShortDescription"=>"BLAU HALL", 
          "BuildingLongDescription"=>"BLAU JEFF T HALL", "BuildingStreetNumber"=>"700", "BuildingStreetDirection"=>"E", 
          "BuildingStreetName"=>"UNIVERSITY AVE", "BuildingCity"=>"ANN ARBOR", "BuildingState"=>"MI", "BuildingPostal"=>"48109", 
          "BuildingTypeDescription"=>"Teach, Research, Support", "BuildingPhaseCode"=>"SERV", "BuildingPhaseDescription"=>"In Service", 
          "BuildingCampusCode"=>"100", "BuildingCampusDescription"=>"Central Campus", "BuildingOwnership"=>"Owned"}]}
        allow_any_instance_of(BuildingApi).to receive(:get_building_info_by_bldrecnbr).with(bldrecnbr).and_return(result)
        visit new_building_path
        fill_in "Building Record Number", with: "1234567"
        click_on "Create Building"
        sleep 3
        expect(page).to have_content("New Building was added.")
      end
    end
  end
end






{"success"=>true, "errorcode"=>"", "error"=>"", "data"=>[{"FiscalYear"=>2024, "BuildingRecordNumber"=>"1234567", "BuildingShortDescription"=>"BLAU HALL", "BuildingLongDescription"=>"BLAU JEFF T HALL", "BuildingStreetNumber"=>"700", "BuildingStreetDirection"=>"E", "BuildingStreetName"=>"UNIVERSITY AVE", "BuildingCity"=>"ANN ARBOR", "BuildingState"=>"MI", "BuildingPostal"=>"48109", "BuildingTypeDescription"=>"Teach, Research, Support", "BuildingPhaseCode"=>"SERV", "BuildingPhaseDescription"=>"In Service", "BuildingCampusCode"=>"100", "BuildingCampusDescription"=>"Central Campus", "BuildingOwnership"=>"Owned"}]}