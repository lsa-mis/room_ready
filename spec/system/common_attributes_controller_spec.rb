require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    mock_login(user)
	end

	context 'create a new common attribute' do
    it 'fills out the form and submits it' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        fill_in "Description", with: "common attribute one"
        check "Needs Checkbox?"
        click_on "Create"
        expect(page).to have_content("Common attribute was successfully created.")
      end
    end
  end

  context 'validate a new common attribute' do
    it 'fills out the form and submits it' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        fill_in "Description", with: "common attribute one"
        click_on "Create"
        expect(page).to have_content("Needs to have either a checkbox or a quantity box, or both.")
      end
    end
  end

  context 'edit a common attribute' do
    let!(:common_attribute) { FactoryBot.create(:common_attribute) }

    it 'click on edit icon and go to edit page' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Edit Common Attribute")
      end
    end

    it 'click on edit icon and cancel editing' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Edit Common Attribute")
        click_on "Cancel"
        expect(page).to have_content(common_attribute.description)
      end
    end

    it 'click on edit icon and update description' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Edit Common Attribute")
        fill_in "Description", with: common_attribute.description + "edited"
        click_on "Update"
        expect(page).to have_content(common_attribute.description + "edited")
      end
    end

    it 'click on delete icon and cancel the alert messege' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
        dismiss_browser_dialog
        expect(page).to_not have_content("Common attribute was successfully deleted.")
      end
    end

    it 'click on cancel icon and accept the alert message' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
        accept_browser_dialog
        expect(page).to have_content("Common attribute was successfully deleted.")
      end
    end
  end
  
end
