# == Schema Information
#
# Table name: specific_attributes
#
#  id                :bigint           not null, primary key
#  description       :string
#  need_checkbox     :boolean
#  need_quantity_box :boolean
#  room_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe SpecificAttribute, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:specific_attribute)).to be_valid
    end
  end

  context "create specific_attribute with all required fields present" do
    it 'is valid' do
      expect(create(:specific_attribute)).to be_valid
    end
  end

  context "create specific_attribute without a description" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Description can\'t be blank"' do
      expect { FactoryBot.create(:specific_attribute, description: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Description can't be blank")
    end
  end

  context "create specific_attribute with a duplicated description for the same room" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Description has already been taken for this room"' do
      specific_attribute = FactoryBot.create(:specific_attribute)
      specific_attribute1 = FactoryBot.build(:specific_attribute,
                                             description: specific_attribute.description,
                                             room: specific_attribute.room)
      expect(specific_attribute1.valid?).to be_falsy
      expect(specific_attribute1.errors.full_messages_for(:description)).to include "Description has already been taken for this room"
    end
  end

  context "create specific_attribute with a duplicated description for different rooms" do
    it 'is valid' do
      specific_attribute = FactoryBot.create(:specific_attribute)
      specific_attribute1 = FactoryBot.build(:specific_attribute, description: specific_attribute.description)
      expect(specific_attribute1).to be_valid
    end
  end

  context "create specific_attribute without need_checkbox and need_quantity_box selected" do
    it 'raises an error: Needs to have either a checkbox or a quantity box, or both.' do
      specific_attribute =  FactoryBot.build(:specific_attribute, need_checkbox: false, need_quantity_box: false)
      expect(specific_attribute.valid?).to be_falsy
      expect(specific_attribute.errors.full_messages_for(:base)).to include "Needs to have either a checkbox or a quantity box, but not both."
    end
  end

  context "create specific_attribute without need_checkbox and need_quantity_box selected" do
    it 'raises an error: Needs to have either a checkbox or a quantity box, or both.' do
      specific_attribute =  FactoryBot.build(:specific_attribute, need_checkbox: true, need_quantity_box: true)
      expect(specific_attribute.valid?).to be_falsy
      expect(specific_attribute.errors.full_messages_for(:base)).to include "Needs to have either a checkbox or a quantity box, but not both."
    end
  end

end
