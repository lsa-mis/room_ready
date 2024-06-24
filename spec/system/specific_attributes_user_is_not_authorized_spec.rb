require 'rails_helper'

RSpec.describe SpecificAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(false)
    mock_login(user)
  end

	context 'create a new specific_attribute' do
    let!(:room) { FactoryBot.create(:room) }
    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "specific_attribute" do
        visit "rooms/#{room.id}/specific_attributes"
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end

  context 'edit a specific_attribute' do
    let!(:specific_attribute) { FactoryBot.create(:specific_attribute) }
    it 'returns a "You are not authorized to perform this action." message' do
      VCR.use_cassette "specific_attribute" do
        room_id = specific_attribute.room.id
        visit "rooms/#{room_id}/specific_attributes/#{specific_attribute}/edit"
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end
end
