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
      expect(FactoryBot.create(:resource)).to be_valid
    end
  end

  context "create resource with all required fields present" do
    it 'is valid' do
      # room = create(:room)  # Assuming you have a factory for rooms since room_id is required
      expect(create(:resource)).to be_valid
    end
  end

  context "create resource without a name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name can\'t be blank"' do
      expect { FactoryBot.create(:resource, name: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end

  context "create resource without a resource_type" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Resource type can\'t be blank"' do
      expect { FactoryBot.create(:resource, resource_type: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Resource type can't be blank")
    end
  end

  context "create resource without a room" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Room must exist"' do
      expect { FactoryBot.create(:resource, room_id: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Room must exist, Room can't be blank")
    end
  end
end
