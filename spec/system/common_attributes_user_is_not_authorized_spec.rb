require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
		mock_login(user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(false)
    session[:role] = "none"
  end

	context 'create a new common attribute' do
    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end

  context 'edit a common attribute' do
    let!(:common_attribute) { FactoryBot.create(:common_attribute) }

    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "common_attribute" do
        visit edit_common_attribute_path(common_attribute)
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end
  
end
