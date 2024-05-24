require 'rails_helper'

RSpec.describe Building, type: :system do

	# before do
	# 	user = FactoryBot.create(:user)
	# 	mock_login(user)
  #   user.membership = ['lsa-roomready-admins']
	# end

  # context "GET 'index'" do
  #   it "returns http success" do
  #     get 'buildings/index'
  #     response.should be_success
  #   end
  # end

	context 'create a new building' do
    it 'fills out the form and submit it' do
      user = FactoryBot.create(:user)
		mock_login(user)
    user.membership = ['lsa-roomready-admins']
    # binding.pry
      puts current_path
      visit new_building_path
      puts current_path
      # binding.pry
      sleep 2
			fill_in "Bldrecnbr", with: "1234567"
			fill_in "Name", with: "Chemistry"
			fill_in "Nick name", with: "Chem"
			fill_in "Address", with: "123 N.University St."
			fill_in "City", with: "Ann Arbor"
			fill_in "State", with: "MI"
			fill_in "Zip", with: "48109"
      sleep 5
			click_on "Create Builging"
      sleep 5
      expect(page).to have_content("A new building was added.")
    end
  end

end
