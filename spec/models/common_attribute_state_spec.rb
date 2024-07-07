# == Schema Information
#
# Table name: common_attribute_states
#
#  id                  :bigint           not null, primary key
#  checkbox_value      :boolean
#  quantity_box_value  :integer
#  room_state_id       :bigint           not null
#  common_attribute_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'

RSpec.describe CommonAttributeState, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:common_attribute_states)).to be_valid
    end
  end

  context "create common_attribute_states with all required fields present" do
    it 'is valid' do
      expect(create(:common_attribute_states)).to be_valid
    end
  end

  context "create common_attribute_states without an is_checked value" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Is checked must be a present (either true or false)"' do
      expect { FactoryBot.create(:common_attribute_states, is_checked: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Is checked must be a present (either true or false)")
    end
  end

  context "edit old common_attribute_states record" do
    it 'is not valid' do
      common_attribute_states = FactoryBot.create(:common_attribute_states)
      common_attribute_states.update(created_at: common_attribute_states.created_at - 1.day, updated_at: common_attribute_states.updated_at - 1.day)
      expect(common_attribute_states.update(is_checked: false)).to be_falsy
      expect(common_attribute_states.errors.full_messages_for(:base)).to include "Old state record cannot be edited"
    end
  end
end
