require 'rails_helper'

RSpec.describe 'About page', type: :system do
  describe 'about page' do
    it 'shows the right content' do
      VCR.use_cassette "about" do
        visit all_root_path
        expect(page).to have_content('About LSA SpaceReady Application')
      end
    end
  end
end
