# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  room_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Note, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:note)).to be_valid
    end
  end

  context "create note with all required fields present" do
    it 'is valid' do
      expect(create(:note)).to be_valid
    end
  end

  context "create note without a description" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Content can\'t be blank"' do
      expect { FactoryBot.create(:note, content: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Content can't be blank")
    end
  end

  context "create note without a room" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Room must exist"' do
      expect { FactoryBot.create(:note, room: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Room must exist")
    end
  end

  context "create note without a user" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Room must exist"' do
      expect { FactoryBot.create(:note, user: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: User must exist")
    end
  end

end
