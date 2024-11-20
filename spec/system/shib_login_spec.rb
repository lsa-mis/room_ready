require 'rails_helper'

RSpec.describe "Controllers", type: :request do

  before do
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-developers').and_return(true)
    allow(LdapLookup).to receive(:is_member_of_group?).with(anything, 'lsa-spaceready-admins').and_return(false)
  end

  describe 'login success' do
    it 'displays welcome message on programs page' do
      # VCR.use_cassette "login" do
        user = FactoryBot.create(:user)
        mock_login(user)
        follow_redirect!
        expect(response.body).to include("Signed in successfully.")
      # end
    end
  end

  describe 'login failure' do
    it 'displays welcome message on programs page' do
      # VCR.use_cassette "login" do
        user = FactoryBot.build(:user, email: "wrongemial")
        mock_login(user)
        expect(response.body).not_to include("Welcome")
      end
    # end
  end

end
