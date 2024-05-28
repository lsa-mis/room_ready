require 'rails_helper'

RSpec.describe CommonAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
		mock_login(user)
    # allow_any_instance_of(User).to receive(:membership).and_return([])
	end

	context 'create a new common attribute' do
    it 'fills out the form and submits it' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end

  context 'edit a common attribute' do
    let!(:common_attribute) { FactoryBot.create(:common_attribute) }

    it 'click an edit icon and go to edit page' do
      VCR.use_cassette "common_attribute" do
        visit edit_common_attribute_path(common_attribute)
        sleep 2
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end

    it 'click an edit icon and update description' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        sleep 2
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        sleep 2
        expect(page).to have_content("Edit Common Attribute")
        fill_in "Description", with: common_attribute.description + "edited"
        click_on "Update"
        sleep 2
        expect(page).to have_content(common_attribute.description + "edited")
      end
    end

    it 'click an delete icon and cancel the alert messege' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        sleep 2
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
        sleep 2
        text = page.driver.browser.switch_to.alert.text
        expect(text).to eq 'Are you sure you want to Delete this Common Attribute?'
        page.driver.browser.switch_to.alert.dismiss
        sleep 2
        expect(page).to have_content(common_attribute.description)
      end
    end

    it 'click an cancel icon and accept the alert message' do
      VCR.use_cassette "common_attribute" do
        visit common_attributes_path
        sleep 2
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
        sleep 2
        text = page.driver.browser.switch_to.alert.text
        expect(text).to eq 'Are you sure you want to delete this Common Attribute?'
        page.driver.browser.switch_to.alert.accept
        sleep 2
        expect(page).to have_content("Common attribute was successfully destroyed.")
      end
    end
  end
  
end
