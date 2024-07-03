# == Schema Information
#
# Table name: resource_states
#
#  id            :bigint           not null, primary key
#  is_checked    :boolean
#  room_state_id :bigint           not null
#  resource_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe ResourceState, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:resource_state)).to be_valid
    end
  end

  context "create resource_state with all required fields present" do
    it 'is valid' do
      expect(create(:resource_state)).to be_valid
    end
  end

  context "create resource_state without an is_checked value" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Is checked can\'t be blank"' do
      expect { FactoryBot.create(:resource_state, is_checked: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Is checked can't be blank")
    end
  end

  context "edit old resource_state record" do
    it 'is not valid' do
      resource_state = FactoryBot.create(:resource_state)
      resource_state.update(created_at: resource_state.created_at - 1.day, updated_at: resource_state.updated_at - 1.day)
      expect(resource_state.update(is_checked: false)).to be_falsy
      expect(resource_state.errors.full_messages_for(:base)).to include "Old resource state record cannot be edited"
    end
  end
end
