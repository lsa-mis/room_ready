require 'rails_helper'

RSpec.describe Building, type: :system do

  before do
		user = FactoryBot.create(:user)
		mock_login(user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    session[:role] = "admin"
  end

	context 'create a new building' do
    it 'fills out the form and submit it' do
      VCR.use_cassette "LdapLookup.is_member_of_group?" do
        visit new_building_path
        sleep 2
        fill_in "Building Record Number", with: "1234567"
        click_on "Create Building"
        expect(page).to have_content("is not valid.")
        sleep 2
      end
    end
  end
end
