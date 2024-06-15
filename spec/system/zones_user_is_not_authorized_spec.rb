require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(false)
		mock_login(user)
	end

	context 'create a new zone' do
    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "zone" do
        visit zones_path
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end

  context 'edit a zone' do
    let!(:zone) { FactoryBot.create(:zone) }

    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "zone" do
        visit edit_zone_path(zone)
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end
  
end
