require 'rails_helper'

RSpec.describe SpecificAttribute, type: :system do

  before do
		user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(true)
    mock_login(user)
	end

	context 'create a new specific attribute' do
    let!(:room) { FactoryBot.create(:room) }
    it 'fills out the form and submits it' do
      visit "rooms/#{room.id}/specific_attributes"
      fill_in "Description", with: "specific attribute one"
      check "Include Yes/No Buttons"
      click_on "Create"
      expect(page).to have_content("Specific attribute was successfully created.")
      expect(SpecificAttribute.find_by(description: "specific attribute one").present?).to be_truthy
    end
  end

  context 'validate a new specific attribute' do
    let!(:room) { FactoryBot.create(:room) }
    it 'fills out the form and submits it' do
      visit "rooms/#{room.id}/specific_attributes"
      fill_in "Description", with: "specific attribute one"
      click_on "Create"
      expect(page).to have_content("Needs to have either a checkbox or a quantity box, but not both.")
    end
  end

  context 'edit a specific attribute' do
    let!(:specific_attribute) { FactoryBot.create(:specific_attribute) }
    let!(:room_id) { specific_attribute.room.id }
    it 'click on edit icon and go to edit page' do
      visit "rooms/#{room_id}/specific_attributes"
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Edit Specific Attribute")
    end

    it 'click on edit icon and cancel editing' do
      visit "rooms/#{room_id}/specific_attributes"
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Edit Specific Attribute")
      click_on "Cancel"
      expect(page).to have_content(specific_attribute.description)
    end

    it 'click on edit icon and update description' do
      visit "rooms/#{room_id}/specific_attributes"
      find(:css, 'i.bi.bi-pencil-square.text-primary').click
      expect(page).to have_content("Edit Specific Attribute")
      fill_in "Description", with: specific_attribute.description + "edited"
      click_on "Update"
      expect(page).to have_content(specific_attribute.description + "edited")
    end

    it 'click on delete icon and cancel the alert messege' do
      specific_attribute_id = specific_attribute.id
      visit "rooms/#{room_id}/specific_attributes"
      dismiss_confirm 'Are you sure you want to delete this specific attribute?' do
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
      end
      expect(page).to_not have_content("Specific attribute was successfully deleted.")
      expect(SpecificAttribute.find(specific_attribute_id).present?).to be_truthy
    end
  end

  context 'edit a specific attribute' do
    let!(:specific_attribute) { FactoryBot.create(:specific_attribute) }
    let!(:room_id) { specific_attribute.room.id }
    it 'click on delete icon and accept the alert message' do
      specific_attribute_id = specific_attribute.id
      visit "rooms/#{room_id}/specific_attributes"
      accept_confirm 'Are you sure you want to delete this specific attribute?' do
        find(:css, 'i.bi.bi-trash-fill.text-danger').click
      end
      expect(page).to have_content("Specific attribute was deleted.")
      expect { SpecificAttribute.find(specific_attribute_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
end
