# == Schema Information
#
# Table name: announcements
#
#  id         :bigint           not null, primary key
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Announcement, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:announcement)).to be_valid
    end
  end

  context "when all required fields are present" do
    it "is valid" do
      announcement = build(:announcement, location: 'Lobby')
      expect(announcement).to be_valid
    end
  end

  context "when required location is not present" do
    it "is invalid" do
      announcement = build(:announcement, location: nil)
      announcement.valid?
      expect(announcement.errors[:location]).to include("can't be blank")
    end
  end
end
