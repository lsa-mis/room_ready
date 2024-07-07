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
      expect(build(:common_attribute_state)).to be_valid
    end
  end

  context "create common_attribute_state without quantity_box_value when common_attribute.need_quantity_box is true" do
    it 'raises an error: Quantity box value can\'t be blank if quantity box is required' do
      common_attribute = FactoryBot.create(:common_attribute, need_quantity_box: true)
      expect { FactoryBot.create(:common_attribute_state, quantity_box_value: nil, common_attribute: common_attribute) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Quantity box value can't be blank if quantity box is required")
    end
  end

  context "create common_attribute_state without checkbox_value when common_attribute.need_checkbox is false" do
    it 'is valid' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, checkbox_value: nil, quantity_box_value: 1, common_attribute: FactoryBot.create(:common_attribute, need_checkbox: false, need_quantity_box: true))
      expect(common_attribute_state).to be_valid
    end
  end

  context "create common_attribute_state without quantity_box_value when common_attribute.need_quantity_box is false" do
    it 'is valid' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, quantity_box_value: nil, common_attribute: FactoryBot.create(:common_attribute, need_quantity_box: false))
      expect(common_attribute_state).to be_valid
    end
  end

  context "create common_attribute_state with checkbox_value when common_attribute.need_checkbox is false" do
    it 'raises an error: Checkbox value must be blank if checkbox is not required' do
      common_attribute = FactoryBot.create(:common_attribute, need_checkbox: false, need_quantity_box: true)
      expect { FactoryBot.create(:common_attribute_state, checkbox_value: true, quantity_box_value: 1, common_attribute: common_attribute) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Checkbox value must be blank if checkbox is not required")
    end
  end

  context "create common_attribute_state with quantity_box_value when common_attribute.need_quantity_box is false" do
    it 'raises an error: Quantity box value must be blank if quantity box is not required' do
      common_attribute = FactoryBot.create(:common_attribute, need_quantity_box: false)
      expect { FactoryBot.create(:common_attribute_state, checkbox_value: true, quantity_box_value: 1, common_attribute: common_attribute) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Quantity box value must be blank if quantity box is not required")
    end
  end

  context "create common_attribute_state with checkbox_value when common_attribute.need_checkbox is true" do
    it 'is valid' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, checkbox_value: true, common_attribute: FactoryBot.create(:common_attribute, need_checkbox: true))
      expect(common_attribute_state).to be_valid
    end
  end

  context "create common_attribute_state with quantity_box_value when common_attribute.need_quantity_box is true" do
    it 'is valid' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, quantity_box_value: 1, common_attribute: FactoryBot.create(:common_attribute, need_quantity_box: true))
      expect(common_attribute_state).to be_valid
    end
  end

  context "update common_attribute_state with checkbox_value when common_attribute.need_checkbox is false" do
    it 'raises an error: Checkbox value must be blank if checkbox is not required' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, checkbox_value: nil, quantity_box_value: 1, common_attribute: FactoryBot.create(:common_attribute, need_checkbox: false, need_quantity_box: true))
      common_attribute_state.update(checkbox_value: true)
      expect(common_attribute_state.valid?).to be_falsy
      expect(common_attribute_state.errors.full_messages_for(:checkbox_value)).to include "Checkbox value must be blank if checkbox is not required"
    end
  end

  context "update common_attribute_state with quantity_box_value when common_attribute.need_quantity_box is false" do
    it 'raises an error: Quantity box value must be blank if quantity box is not required' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, quantity_box_value: nil, common_attribute: FactoryBot.create(:common_attribute, need_quantity_box: false))
      common_attribute_state.update(quantity_box_value: 1)
      expect(common_attribute_state.valid?).to be_falsy
      expect(common_attribute_state.errors.full_messages_for(:quantity_box_value)).to include "Quantity box value must be blank if quantity box is not required"
    end
  end

  context "update common_attribute_state without checkbox_value when common_attribute.need_checkbox is true" do
    it 'raises an error: Checkbox value can\'t be blank if checkbox is required' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, checkbox_value: true, common_attribute: FactoryBot.create(:common_attribute, need_checkbox: true))
      common_attribute_state.update(checkbox_value: nil)
      expect(common_attribute_state.valid?).to be_falsy
      expect(common_attribute_state.errors.full_messages_for(:checkbox_value)).to include "Checkbox value can't be blank if checkbox is required"
    end
  end

  context "update common_attribute_state without quantity_box_value when common_attribute.need_quantity_box is true" do
    it 'raises an error: Quantity box value can\'t be blank if quantity box is required' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, quantity_box_value: 1, common_attribute: FactoryBot.create(:common_attribute, need_quantity_box: true))
      common_attribute_state.update(quantity_box_value: nil)
      expect(common_attribute_state.valid?).to be_falsy
      expect(common_attribute_state.errors.full_messages_for(:quantity_box_value)).to include "Quantity box value can't be blank if quantity box is required"
    end
  end

  context "update common_attribute_state without checkbox_value when common_attribute.need_checkbox is false" do
    it 'is valid' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, checkbox_value: nil, quantity_box_value: 1, common_attribute: FactoryBot.create(:common_attribute, need_checkbox: false, need_quantity_box: true))
      common_attribute_state.update(checkbox_value: nil)
      expect(common_attribute_state).to be_valid
    end
  end

  context "update common_attribute_state without quantity_box_value when common_attribute.need_quantity_box is false" do
    it 'is valid' do
      common_attribute_state = FactoryBot.create(:common_attribute_state, quantity_box_value: nil, common_attribute: FactoryBot.create(:common_attribute, need_quantity_box: false))
      common_attribute_state.update(quantity_box_value: nil)
      expect(common_attribute_state).to be_valid
    end
  end

  context "creat common_attribute_state with the same common_attribute_id and room_state_id" do
    it 'raises an error: There can only be one Common Attribute State per Common Attribute per Room State' do
      common_attribute = FactoryBot.create(:common_attribute)
      room_state = FactoryBot.create(:room_state)
      FactoryBot.create(:common_attribute_state, common_attribute: common_attribute, room_state: room_state)
      expect { FactoryBot.create(:common_attribute_state, common_attribute: common_attribute, room_state: room_state) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: There can only be one Common Attribute State per Common Attribute per Room State")
    end
  end
end
