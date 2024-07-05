# == Schema Information
#
# Table name: common_attributes
#
#  id                :bigint           not null, primary key
#  description       :string
#  need_checkbox     :boolean
#  need_quantity_box :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  archived          :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe CommonAttribute, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:common_attribute)).to be_valid
    end
  end

  context "create common_attribute with all required fields present" do
    it 'is valid' do
      expect(build(:common_attribute)).to be_valid
    end
  end

  context "create common_attribute without a description" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Description can\'t be blank"' do
      expect { FactoryBot.create(:common_attribute, description: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Description can't be blank")
    end
  end

  context "create common_attribute with a duplicated description" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Description has already been taken"' do
      common_attribute = FactoryBot.create(:common_attribute)
      common_attribute1 = FactoryBot.build(:common_attribute, description: common_attribute.description)
      expect(common_attribute1.valid?).to be_falsy
      expect(common_attribute1.errors.full_messages_for(:description)).to include "Description has already been taken"
    end
  end

  context "create common_attribute without need_checkbox and need_quantity_box selected" do
    it 'raises an error: Needs to have either a checkbox or a quantity box, or both.' do
      common_attribute =  FactoryBot.build(:common_attribute, need_checkbox: false, need_quantity_box: false)
      expect(common_attribute.valid?).to be_falsy
      expect(common_attribute.errors.full_messages_for(:base)).to include "Needs to have either a checkbox or a quantity box, or both."
    end
  end
end
