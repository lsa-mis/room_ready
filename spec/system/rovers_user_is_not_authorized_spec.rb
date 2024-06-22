require 'rails_helper'

RSpec.describe Rover, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(false)
		mock_login(user)
	end

	context 'create a new rover' do
    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "rover" do
        visit rovers_path
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end

  context 'edit a rover' do
    let!(:rover) { FactoryBot.create(:rover) }

    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "rover" do
        visit edit_rover_path(rover)
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end
  
end
