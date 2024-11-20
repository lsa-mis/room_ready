require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins-readonly').and_return(false)
		mock_login(user)
	end

	context 'create a new room' do
    let!(:building) { FactoryBot.create(:building) }
    it 'returns a "You are not authorized to perform this action." message' do
      # VCR.use_cassette "room" do
        visit "rooms/new?building_id=#{building.id}"
        visit "rooms/new?building_id=#{building.id}"
        expect(page).to have_content("You are not authorized to perform this action.")
      # end
    end
  end

  context 'show a room' do
    let!(:room) { FactoryBot.create(:room) }
    it 'returns a "You are not authorized to perform this action." message' do
      # VCR.use_cassette "room" do
        visit "rooms/#{room.id}"
        visit "rooms/#{room.id}"
        expect(page).to have_content("You are not authorized to perform this action.")
      # end
    end
  end
  
end
