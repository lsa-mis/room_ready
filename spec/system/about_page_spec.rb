require 'rails_helper'

RSpec.describe 'About page', type: :system do
  describe 'about page' do
    it 'shows the right content' do
      visit root_path
      sleep(5)
      expect(page).to have_content('About Room Ready Application')
    end
  end
end