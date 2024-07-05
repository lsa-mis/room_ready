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
      expect(build(:common_attribute_state)).to be_valid
    end
  end

  context "create common_attribute_state with all required fields present" do
    it 'is valid' do
      expect(create(:common_attribute_state)).to be_valid
    end
  end

  context "create common_attribute_state without checkbox_value when common_attribute.need_checkbox is true" do
    it 'raises an error: Checkbox value can\'t be blank if checkbox is required' do
      common_attribute = FactoryBot.create(:common_attribute, need_checkbox: true)
      expect { FactoryBot.create(:common_attribute_state, checkbox_value: nil, common_attribute: common_attribute) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Checkbox value can't be blank if checkbox is required")
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
end
