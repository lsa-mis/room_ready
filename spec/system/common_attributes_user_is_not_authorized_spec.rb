require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins-readonly').and_return(false)
    mock_login(user)
  end

	context 'create a new common attribute' do
    it 'returns a "You are not authorized to perform this action." message' do
      # VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        visit common_attributes_path
        expect(page).to have_content("You are not authorized to perform this action.")
      # end
    end
  end

  context 'edit a common attribute' do
    let!(:common_attribute) { FactoryBot.create(:common_attribute) }

    it 'returns a "You are not authorized to perform this action." message' do
      # VCR.use_cassette "common_attribute" do
        visit edit_common_attribute_path(common_attribute)
        visit edit_common_attribute_path(common_attribute)
        expect(page).to have_content("You are not authorized to perform this action.")
      # end
    end
  end
  
end
