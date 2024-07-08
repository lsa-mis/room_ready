# == Schema Information
#
# Table name: specific_attribute_states
#
#  id                    :bigint           not null, primary key
#  checkbox_value        :boolean
#  quantity_box_value    :integer
#  room_state_id         :bigint           not null
#  specific_attribute_id :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'rails_helper'

RSpec.describe SpecificAttributeState, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:specific_attribute_state)).to be_valid
    end
  end

  context "create specific_attribute_state with all required fields present" do
    it 'is valid' do
      expect(create(:specific_attribute_state)).to be_valid
    end
  end

  context "create specific_attribute_state without a checkbox_value for specific attribute that needs checkbox" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Checkbox value can\'t be blank if checkbox is required"' do
      room = FactoryBot.create(:room)
      room_state = FactoryBot.create(:room_state, room: room)
      specific_attribute = FactoryBot.create(:specific_attribute, room: room, need_checkbox: true)
      state = FactoryBot.build(:specific_attribute_state,
                               room_state: room_state,
                               specific_attribute: specific_attribute,
                               checkbox_value: nil)

      expect(state.valid?).to be_falsy
      expect(state.errors.full_messages_for(:checkbox_value)).to include "Checkbox value can't be blank if checkbox is required"
    end
  end

  context "create specific_attribute_state without a quantity_box_value for specific attribute that needs quantity box" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Quantity box value can\'t be blank if quantity box is required"' do
      room = FactoryBot.create(:room)
      room_state = FactoryBot.create(:room_state, room: room)
      specific_attribute = FactoryBot.create(:specific_attribute, room: room, need_quantity_box: true, need_checkbox: false)
      state = FactoryBot.build(:specific_attribute_state,
                               room_state: room_state,
                               specific_attribute: specific_attribute,
                               quantity_box_value: nil)

      expect(state.valid?).to be_falsy
      expect(state.errors.full_messages_for(:quantity_box_value)).to include "Quantity box value can't be blank if quantity box is required"
    end
  end

  context "edit old specific_attribute_state record" do
    it 'is not valid' do
      specific_attribute_state = FactoryBot.create(:specific_attribute_state)
      specific_attribute_state.update(created_at: specific_attribute_state.created_at - 1.day, updated_at: specific_attribute_state.updated_at - 1.day)
      expect(specific_attribute_state.update(quantity_box_value: 4)).to be_falsy
      expect(specific_attribute_state.errors.full_messages_for(:base)).to include "Old state record cannot be edited"
    end
  end
end
