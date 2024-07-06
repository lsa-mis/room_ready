require 'rails_helper'

RSpec.describe Rover, type: :system do

  before do
    user = FactoryBot.create(:user)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-developers').and_return(false)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-roomready-admins').and_return(true)
    mock_login(user)
  end

  context 'create a new rover with invalid uniqname' do
    it 'returns "uniqname is invalid" message' do
      VCR.use_cassette "building" do
        uniqname = 'randomname'
        result = {"valid"=>false, "note"=>"The 'randomname' uniqname is not valid.", "last_name"=>"", "first_name"=>"", "name"=>""}
        allow_any_instance_of(RoversController).to receive(:get_rover_info).with(uniqname).and_return(result)
        visit rovers_path
        fill_in "Create Rover by Uniqname", with: uniqname
        click_on "Create"
        expect(page).to have_content("is not valid.")
        expect(Rover.find_by(uniqname: uniqname).present?).to be_falsy
      end
    end
  end

  context 'create a new rover with valid uniqname' do
    it 'returns "Rover was successfully created" message' do
      VCR.use_cassette "rover" do
        uniqname = 'qwerty'
        result = {"valid"=>true, "note"=>"Uniqname is valid", "last_name"=>"Lastname", "first_name"=>"Firstname", "name"=>"Firstname Lastname"}
        allow_any_instance_of(RoversController).to receive(:get_rover_info).with(uniqname).and_return(result)
        visit rovers_path
        fill_in "Create Rover by Uniqname", with: uniqname
        click_on "Create"
        expect(page).to have_content("Rover was successfully created.")
        expect(Rover.find_by(uniqname: uniqname).present?).to be_truthy
      end
    end
  end

  context 'edit a rover' do
    let!(:rover) { FactoryBot.create(:rover) }
    it 'go to Editing Rover page' do
      VCR.use_cassette "rover" do
        visit rovers_path
        find(:css, 'i.bi.bi-pencil-square.text-primary').click
        expect(page).to have_content("Editing Rover")
      end
    end
  end

  context 'delete a rover' do
    let!(:rover) { FactoryBot.create(:rover) }
    it 'click on delete icon and cancel deleting' do
      VCR.use_cassette "rover" do
        rover_id = rover.id
        visit rovers_path
        dismiss_confirm 'Are you sure you want to delete this rover?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to_not have_content("Rover was successfully deleted.")
        expect(Rover.find(rover_id).present?).to be_truthy
      end
    end

    it 'click on delete icon and delete rover' do
      VCR.use_cassette "rover" do
        rover_id = rover.id
        visit rovers_path
        accept_confirm 'Are you sure you want to delete this rover?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("Rover was successfully deleted.")
        expect { Rover.find(rover_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'fail deleting a rover' do
    let!(:rover) { create(:rover) }

    it 'click on delete icon and delete returns error' do
      allow(rover).to receive(:destroy).and_return(false)
      allow(Rover).to receive(:find).and_return(rover)
      VCR.use_cassette "rover" do
        visit rovers_path
        accept_confirm 'Are you sure you want to delete this rover?' do
          find(:css, 'i.bi.bi-trash-fill.text-danger').click
        end
        expect(page).to have_content("Error deleting rover.")
      end
    end
  end

end
