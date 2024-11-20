require 'rails_helper'

RSpec.describe Zone, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(true)
    mock_login(user)
  end

	context 'create a new zone' do
    it 'fills out the form and submits it' do
      visit zones_path
      click_on "Add New Zone"
      fill_in "Name", with: "Zone A"
      click_on "Create Zone"
      expect(page).to have_content("Zone was successfully created.")
      expect(Zone.find_by(name: "Zone A").present?).to be_truthy
    end
  end

  context 'edit a zone' do
    let!(:zone) { FactoryBot.create(:zone) }

    it 'click on edit icon and go to edit page' do
      visit zones_path
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Editing Zone")
    end

    it 'click on edit icon and cancel editing' do
      visit zones_path
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Editing Zone")
      click_on "Cancel"
      expect(page).to have_content(zone.name)
    end

    it 'click on edit icon and update name' do
      visit zones_path
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Editing Zone")
      fill_in "Name", with: zone.name + "edited"
      click_on "Update"
      expect(page).to have_content(zone.name + "edited")
    end

    it 'click on delete icon and cancel the alert message' do
      zone_id = zone.id
      visit zones_path
      # dismiss_browser_dialog
      dismiss_confirm 'Are you sure you want to delete this zone?' do
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
      end
      expect(Zone.find(zone_id).present?).to be_truthy
    end

    it 'click on cancel icon and accept the alert message' do
      zone_id = zone.id
      visit zones_path
      # accept_browser_dialog
      accept_confirm 'Are you sure you want to delete this zone?' do
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
      end
      expect(page).to have_content("Zone was successfully deleted.")
      expect { Zone.find(zone_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
end
