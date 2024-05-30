require 'rails_helper'

RSpec.describe Building, type: :system do

  before do
		user = FactoryBot.create(:user)
		mock_login(user)
    allow_any_instance_of(User).to receive(:membership).and_return(['lsa-roomready-admins'])
	end

	context 'create a new building' do
    it 'fills out the form and submit it' do
      VCR.use_cassette "LdapLookup.is_member_of_group?" do
        visit new_building_path
        sleep 2
        fill_in "Bldrecnbr", with: "1234567"
        fill_in "Name", with: "Chemistry"
        fill_in "Nick name", with: "Chem"
        fill_in "Address", with: "123 N.University St."
        fill_in "City", with: "Ann Arbor"
        fill_in "State", with: "MI"
        fill_in "Zip", with: "48109"
        sleep 5
        click_on "Create Building"
        sleep 5
        expect(page).to have_content("Building was successfully created.")
      end
    end
  end

end
