# specify "user login is remembered across browser restarts" do
#     log_in_as_user
#     should_be_logged_in
#     #browser restart = session cookie is lost
#     expire_cookies
#     should_be_logged_in
#   end


  require 'rails_helper'

  RSpec.describe "Controllers", type: :request do
  
    describe 'login success' do
      it 'displays welcome message on programs page' do
        user = FactoryBot.create(:user)
        mock_login(user)
        follow_redirect!
        binding.pry
        create_cookie("role", "admin")
        expect(response.body).to include("Signed in successfully.")

      end
    end
  
    # describe 'login failure' do
    #   it 'displays welcome message on programs page' do
    #     user = FactoryBot.build(:user, email: "wrongemial")
    #     mock_login(user)
    #     expect(response.body).not_to include("Welcome")
    #   end
    # end
  
  end