# == Schema Information
#
# Table name: resources
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  room_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Resource, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:resource)).to be_valid
    end
  end

  context "when all required fields are present" do
    it "is valid" do
      room = create(:room)
      resource = build(:resource, room: room)
      expect(resource).to be_valid
    end
  end

  context "when name is not present" do
    it "is invalid" do
      room = create(:room)
      resource = build(:resource, name: nil, room: room)
      resource.valid?
      expect(resource.errors[:name]).to include("can't be blank")
    end
  end

  context "when resource_type is not present" do
    it "is invalid" do
      room = create(:room)
      resource = build(:resource, resource_type: nil, room: room)
      resource.valid?
      expect(resource.errors[:resource_type]).to include("can't be blank")
    end
  end

  context "when associated room does not exist" do
    it "is invalid" do
      resource = build(:resource, room_id: nil)
      resource.valid?
      expect(resource.errors[:room]).to include("must exist")
    end
  end
end
