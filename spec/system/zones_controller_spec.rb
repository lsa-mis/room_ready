require 'rails_helper'

RSpec.describe Zone, type: :system do

  before do
		user = FactoryBot.create(:user)
		mock_login(user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    session[:role] = "admin"
  end

	context 'create a new zone' do
    it 'fills out the form and submits it' do
      VCR.use_cassette "zone" do
        visit zones_path
        click_on "Add New Zone"
        sleep 2
        fill_in "Name", with: "Zone A"
        click_on "Create Zone"
        sleep 2
        expect(page).to have_content("Zone was successfully created.")
      end
    end
  end

  context 'edit a zone' do
    let!(:zone) { FactoryBot.create(:zone) }

    it 'click on edit icon and go to edit page' do
      VCR.use_cassette "zone" do
        visit zones_path
        sleep 2
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        sleep 2
        expect(page).to have_content("Editing Zone")
      end
    end

    it 'click on edit icon and cancel editing' do
      VCR.use_cassette "zone" do
        visit zones_path
        sleep 2
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        sleep 2
        expect(page).to have_content("Editing Zone")
        click_on "Cancel"
        expect(page).to have_content(zone.name)
      end
    end

    it 'click on edit icon and update name' do
      VCR.use_cassette "zone" do
        visit zones_path
        sleep 2
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        sleep 2
        expect(page).to have_content("Editing Zone")
        fill_in "Name", with: zone.name + "edited"
        click_on "Update"
        sleep 2
        expect(page).to have_content(zone.name + "edited")
      end
    end

    it 'click on delete icon and cancel the alert message' do
      VCR.use_cassette "zone" do
        visit zones_path
        sleep 2
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
        sleep 2
        text = page.driver.browser.switch_to.alert.text
        expect(text).to eq 'Are you sure you want to delete this zone?'
        page.driver.browser.switch_to.alert.dismiss
        sleep 2
        expect(page).to have_content(zone.name)
      end
    end

    it 'click on cancel icon and accept the alert message' do
      VCR.use_cassette "zone" do
        visit zones_path
        sleep 2
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
        sleep 2
        text = page.driver.browser.switch_to.alert.text
        expect(text).to eq 'Are you sure you want to delete this zone?'
        page.driver.browser.switch_to.alert.accept
        sleep 2
        expect(page).to have_content("Zone was successfully deleted.")
      end
    end
  end
  
end
