require 'rails_helper'

RSpec.describe Rover, type: :system do

  before do
    load "#{Rails.root}/spec/support/test_seeds.rb" 
    rover = FactoryBot.create(:rover)
    user = FactoryBot.create(:user, uniqname: rover.uniqname)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins-readonly').and_return(false)
    mock_login(user)
  end

  context 'navigate to start checking a room' do
    let!(:room) { FactoryBot.create(:room) }

    it 'see the Begin Room Check form' do
      # VCR.use_cassette "rover_navigation" do
        floor_name  = "Floor " + room.floor.name
        building = room.floor.building
        zone = building.zone
        visit welcome_rovers_path
        click_on 'Rover Form'
        visit "/rover_navigation/zones"
        expect(page).to have_content("Zones Available")
        click_on "Zone A Details"
        click_on "Select Floor"
        click_on floor_name
        expect(page).to have_content("Rooms for " + building.name)
        click_on "Start Checking " + room.room_number
        expect(page).to have_content("Begin Room Check for Room " + room.room_number)
      # end
    end
  end

  context 'navigate to start checking a room' do
    let!(:room) { FactoryBot.create(:room) }

    it 'see the Begin Room Check form' do
      # VCR.use_cassette "rover_navigation" do
        floor_name  = "Floor " + room.floor.name
        building = room.floor.building
        zone = building.zone
        visit welcome_rovers_path
        click_on 'Rover Form'
        visit "/rooms/#{room.id}/room_states/new"
        expect(page).to have_content("Begin Room Check for Room " + room.room_number)
        expect(page).to have_content("Can you access the room?")
        find(:label, 'Yes').click
        click_on "Start Room Check"
        expect(page).to have_content("Check Confirmation")
        expect(room.room_states.last.is_accessed).to be_truthy
      # end
    end
  end

  context 'navigate to start checking a room' do
    let!(:room) { FactoryBot.create(:room) }

    it 'see the Begin Room Check form' do
      # VCR.use_cassette "rover_navigation" do
        floor_name  = "Floor " + room.floor.name
        building = room.floor.building
        zone = building.zone
        visit welcome_rovers_path
        click_on 'Rover Form'
        visit "/rooms/#{room.id}/room_states/new"
        expect(page).to have_content("Begin Room Check for Room " + room.room_number)
        expect(page).to have_content("Can you access the room?")
        find(:label, 'No').click
        expect(page).to have_content("Can not access the room because:")
        select "Select Reason"
        select "reason one"
        click_on "Start Room Check"
        expect(page).to have_content("Check Confirmation")
        expect(room.room_states.last.is_accessed).to be_falsy
      # end
    end
  end
end
