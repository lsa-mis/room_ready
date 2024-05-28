# == Schema Information
#
# Table name: rovers
#
#  id         :bigint           not null, primary key
#  uniqname   :string
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Rover, type: :model do

  context "the Factory" do
    it 'is valid' do
      expect(build(:rover)).to be_valid
    end
  end

  context "create rover with all required fields present" do
    it 'is valid' do
      expect(create(:rover, uniqname: 'zfzheng')).to be_valid
    end
  end

  context "create building without a uniqname" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Uniqname can\'t be blank"' do
      expect { FactoryBot.create(:rover, uniqname: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Uniqname can't be blank")
    end
  end

  context "create building with a duplicated uniqname" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Uniqname has already been taken"' do
      rover = FactoryBot.create(:rover)
      rover1 = FactoryBot.build(:rover, uniqname: rover.uniqname)
      expect(rover1.valid?).to be_falsy
      expect(rover1.errors.full_messages_for(:uniqname)).to include "Uniqname has already been taken"
    end
  end
  
end
