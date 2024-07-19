# == Schema Information
#
# Table name: floors
#
#  id          :bigint           not null, primary key
#  name        :string
#  building_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Floor, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:floor)).to be_valid
    end
  end

  context "create floor with all required fields present" do
    it 'is valid' do
      expect(create(:floor)).to be_valid
    end
  end

  context "create floor without a name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name can\'t be blank"' do
      expect { FactoryBot.create(:floor, name: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end
end
