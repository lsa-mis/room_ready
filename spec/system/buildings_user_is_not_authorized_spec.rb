require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins-readonly').and_return(false)
		mock_login(user)
	end

	context 'create a new building' do
    it 'returns a "You are not authorized to perform this action." message' do
      visit buildings_path
      visit buildings_path
      expect(page).to have_content("You are not authorized to perform this action.")
    end
  end

  context 'edit a building' do
    let!(:building) { FactoryBot.create(:building) }

    it 'returns a "You are not authorized to perform this action." message' do
      visit edit_building_path(building)
      visit edit_building_path(building)
      expect(page).to have_content("You are not authorized to perform this action.")
    end
  end
  
end
