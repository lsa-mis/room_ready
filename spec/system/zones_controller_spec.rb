require 'rails_helper'

RSpec.describe Zone, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    mock_login(user)
  end

	context 'create a new zone' do
    it 'fills out the form and submits it' do
      VCR.use_cassette "zone" do
        visit zones_path
        click_on "Add New Zone"
        fill_in "Name", with: "Zone A"
        click_on "Create Zone"
        expect(page).to have_content("Zone was successfully created.")
      end
    end
  end

  context 'edit a zone' do
    let!(:zone) { FactoryBot.create(:zone) }

    it 'click on edit icon and go to edit page' do
      VCR.use_cassette "zone" do
        visit zones_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Editing Zone")
      end
    end

    it 'click on edit icon and cancel editing' do
      VCR.use_cassette "zone" do
        visit zones_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Editing Zone")
        click_on "Cancel"
        expect(page).to have_content(zone.name)
      end
    end

    it 'click on edit icon and update name' do
      VCR.use_cassette "zone" do
        visit zones_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Editing Zone")
        fill_in "Name", with: zone.name + "edited"
        click_on "Update"
        expect(page).to have_content(zone.name + "edited")
      end
    end

    it 'click on delete icon and cancel the alert message' do
      VCR.use_cassette "zone" do
        visit zones_path
        # dismiss_browser_dialog
        dismiss_confirm 'Are you sure you want to delete this zone?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to_not have_content("Zone was successfully deleted.")
      end
    end

    it 'click on cancel icon and accept the alert message' do
      VCR.use_cassette "zone" do
        visit zones_path
        # accept_browser_dialog
        accept_confirm 'Are you sure you want to delete this zone?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("Zone was successfully deleted.")
      end
    end
  end
  
end
