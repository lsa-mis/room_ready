require 'rails_helper'

RSpec.describe Note, type: :system do

  before do
	user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(true)
    mock_login(user)
  end

  context 'create a new note on room show page' do
    let!(:room) { FactoryBot.create(:room) }
    it 'fills out a new note form' do
      visit "rooms/#{room.id}"
      fill_in_trix_editor("note_content", with: "Hello world!")
      click_on "Add Note"
      expect(page).to have_content("Updated on")
      expect(Note.find_by(room_id: room.id).content.body.to_s.include?("Hello world!")).to be_truthy
    end
  end

end
