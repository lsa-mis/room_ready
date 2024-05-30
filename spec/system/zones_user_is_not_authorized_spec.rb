require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
		mock_login(user)
    # user.membership is [] - user should not have access to any CommonAttribute routes
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
