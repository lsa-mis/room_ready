# == Schema Information
#
# Table name: zones
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Zone, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:zone)).to be_valid
    end
  end

  context "create zone with all required fields present" do
    it 'is valid' do
      expect(create(:zone)).to be_valid
    end
  end

  context "create zone without a name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name can\'t be blank"' do
      expect { FactoryBot.create(:zone, name: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end

  context "create zone with a duplicated name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name has already been taken"' do
      zone = FactoryBot.create(:zone)
      zone1 = FactoryBot.build(:zone, name: zone.name)
      expect(zone1.valid?).to be_truthy
      expect(zone1.errors.full_messages_for(:name)).to include "Name has already been taken"
    end
  end
end
