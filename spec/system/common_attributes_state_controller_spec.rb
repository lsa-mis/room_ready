require 'rails_helper'

RSpec.describe CommonAttributeState, type: :system do

  before do
    load "#{Rails.root}/spec/support/test_seeds.rb" 
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    mock_login(user)
	end

	context 'create a new common attribute state' do
    let!(:room) { FactoryBot.create(:room) }
    let!(:common_attribute1) { FactoryBot.create(:common_attribute) }
    let!(:common_attribute2) { FactoryBot.create(:common_attribute) }

    it 'fills out the form and submits it' do
      VCR.use_cassette "common_attribute_state" do
        visit "rooms/#{room.id}/room_states/new"
        find(:label, 'Yes').click
        click_on "Create Room State"
        expect(page).to have_content("Common Room Questions")
        find('label[for=common_attribute_states_0_checkbox_value_true]').click
        find('label[for=common_attribute_states_1_checkbox_value_true]').click
        click_on "Save Response"
        expect(page).to have_content("Room Check Confirmation")
      end
    end
  end
  
  context 'edit a common attribute state' do
    let!(:room) { FactoryBot.create(:room) }
    let!(:common_attribute1) { FactoryBot.create(:common_attribute) }
    let!(:common_attribute2) { FactoryBot.create(:common_attribute) }
    let!(:room_state) { FactoryBot.create(:room_state, room: room) }
    let!(:common_attribute_state1) { FactoryBot.create(:common_attribute_state, room_state: room_state, common_attribute: common_attribute1) }
    let!(:common_attribute_state2) { FactoryBot.create(:common_attribute_state, room_state: room_state, common_attribute: common_attribute2) }
    let!(:common_attribute2) { FactoryBot.create(:common_attribute) }

    it 'fills out the form and submits it' do
      VCR.use_cassette "common_attribute_state" do
        visit "rooms/#{room.id}/room_states/#{room_state.id}/edit"
        click_on "Update Room State"
        expect(page).to have_content("Editing Common Room Questions")
        find('label[for=common_attribute_states_0_checkbox_value_true]').click
        find('label[for=common_attribute_states_1_checkbox_value_true]').click
        click_on "Update Response"
        expect(page).to have_content("Room Check Confirmation")
      end
    end
  end

end
