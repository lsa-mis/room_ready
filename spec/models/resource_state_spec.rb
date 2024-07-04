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
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Is checked must be a present (either true or false)"' do
      expect { FactoryBot.create(:resource_state, is_checked: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Is checked must be a present (either true or false)")
    end
  end
end
