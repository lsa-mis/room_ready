require 'rails_helper'

RSpec.describe Building, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(true)
    mock_login(user)
  end

	context 'create a new building with invalid bldrecnbr' do
    it 'returns "bldrecnbr is invalid" message' do
      VCR.use_cassette "building" do
        bldrecnbr = '1234567'
        result = {"success"=>false, "errorcode"=>"", "error"=>"Building record number 123456 is not valid. ", "data"=>{}}
        allow_any_instance_of(BuildingApi).to receive(:get_building_info_by_bldrecnbr).with(bldrecnbr).and_return(result)
        visit new_building_path
        fill_in "Building Record Number", with: bldrecnbr
        click_on "Create Building"
        expect(page).to have_content("is not valid.")
        expect(Building.find_by(bldrecnbr: bldrecnbr).present?).to be_falsy
      end
    end
  end

  context 'create a new building with valid bldrecnbr' do
    it 'returns "New Building was added" message' do
      VCR.use_cassette "building" do
        bldrecnbr = '1234567'
        result = {"success"=>true, "errorcode"=>"", "error"=>"", 
          "data"=>[{"FiscalYear"=>2024, "BuildingRecordNumber"=>"1234567", "BuildingShortDescription"=>"BLAU HALL", 
          "BuildingLongDescription"=>"BLAU JEFF T HALL", "BuildingStreetNumber"=>"700", "BuildingStreetDirection"=>"E", 
          "BuildingStreetName"=>"UNIVERSITY AVE", "BuildingCity"=>"ANN ARBOR", "BuildingState"=>"MI", "BuildingPostal"=>"48109", 
          "BuildingTypeDescription"=>"Teach, Research, Support", "BuildingPhaseCode"=>"SERV", "BuildingPhaseDescription"=>"In Service", 
          "BuildingCampusCode"=>"100", "BuildingCampusDescription"=>"Central Campus", "BuildingOwnership"=>"Owned"}]}
        allow_any_instance_of(BuildingApi).to receive(:get_building_info_by_bldrecnbr).with(bldrecnbr).and_return(result)
        allow_any_instance_of(BuildingApi).to receive(:get_classrooms_for_building).with(bldrecnbr).and_return({})
        visit new_building_path
        fill_in "Building Record Number", with: bldrecnbr
        click_on "Create Building"
        expect(page).to have_content("New Building was added")
        expect(Building.find_by(bldrecnbr: bldrecnbr).present?).to be_truthy
      end
    end
  end

	context 'edit a building' do
    it 'returns "bldrecnbr is invalid" message' do
      VCR.use_cassette "building" do
        bldrecnbr = create(:building)
        visit buildings_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Editing Building")
      end
    end
  end

  it 'click on edit icon and cancel editing' do
    VCR.use_cassette "building" do
      building = create(:building)
      visit buildings_path
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Editing Building")
      click_on "Cancel"
      expect(page).to have_content(building.name)
    end
  end

  it 'click on edit icon and update name' do
    VCR.use_cassette "building" do
      building = create(:building)
      visit buildings_path
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Editing Building")
      fill_in "Nickname", with: building.nick_name + "edited"
      click_on "Update"
      expect(page).to have_content(building.nick_name + "edited")
    end
  end

  context 'delete a building' do
    let!(:building) { FactoryBot.create(:building) }
    let!(:floor) { FactoryBot.create(:floor, building: building) }
    let!(:room1) { FactoryBot.create(:room, floor: floor) }
    let!(:room2) { FactoryBot.create(:room, floor: floor) }
    let!(:resource1) { FactoryBot.create(:resource, room: room1) }
    let!(:resource2) { FactoryBot.create(:resource, room: room1) }
    let!(:specific_attribute1) { FactoryBot.create(:specific_attribute, room: room1) }
    let!(:specific_attribute2) { FactoryBot.create(:specific_attribute, room: room2) }

    it 'and delete all rooms etc' do
      VCR.use_cassette "building" do
        building_id = building.id
        visit "buildings/#{building_id}"
        accept_confirm 'Are you sure you want to delete this building?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("The building was deleted")
        expect { Building.find(building_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it 'fail deleting a building' do
      allow(building).to receive(:delete).and_return(false)
      allow(Building).to receive(:find).and_return(building)
      VCR.use_cassette "building" do
        building_id = building.id
        visit "buildings/#{building_id}"
        accept_confirm 'Are you sure you want to delete this building?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("Error deleting building.")
      end
    end

    it 'fail deleting a building' do
      allow_any_instance_of(BuildingsController).to receive(:delete_building).with(building).and_return(false)
      allow(Building).to receive(:find).and_return(building)
      VCR.use_cassette "building" do
        building_id = building.id
        visit "buildings/#{building_id}"
        accept_confirm 'Are you sure you want to delete this building?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("Error deleting building.")
        expect(Building.find(building_id).present?).to be_truthy
      end
    end

  end
end
