# == Schema Information
#
# Table name: buildings
#
#  id         :bigint           not null, primary key
#  bldrecnbr  :string
#  name       :string
#  nick_name  :string
#  address    :string
#  city       :string
#  state      :string
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  zone_id    :bigint
#
require 'rails_helper'

RSpec.describe Building, type: :model do
  context "the Factory" do
    it 'is valid' do
      expect(build(:building)).to be_valid
    end
  end

  context "create building with all required fields present" do
    it 'is valid' do
      expect(create(:building, nick_name: nil)).to be_valid
    end
  end

  context "create building without a bldrecnbr" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Bldrecnbr can\'t be blank"' do
      expect { FactoryBot.create(:building, bldrecnbr: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Bldrecnbr can't be blank")
    end
  end

  context "create building without a name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name can\'t be blank"' do
      expect { FactoryBot.create(:building, name: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end
  end

  context "create building without an address" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Address can\'t be blank"' do
      expect { FactoryBot.create(:building, address: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Address can't be blank")
    end
  end

  context "create building without a city" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: City can\'t be blank"' do
      expect { FactoryBot.create(:building, city: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: City can't be blank")
    end
  end

  context "create building without a state" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: State can\'t be blank"' do
      expect { FactoryBot.create(:building, state: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: State can't be blank")
    end
  end

  context "create building without a zip" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Zip can\'t be blank"' do
      expect { FactoryBot.create(:building, zip: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Zip can't be blank")
    end
  end

  context "create building without a zone" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Zone must exist"' do
      expect { FactoryBot.create(:building, zone: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Zone must exist")
    end
  end

  context "create building with a duplicated bldrecnbr" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Bldrecnbr has already been taken"' do
      building = FactoryBot.create(:building)
      building1 = FactoryBot.build(:building, bldrecnbr: building.bldrecnbr)
      expect(building1.valid?).to be_falsy
      expect(building1.errors.full_messages_for(:bldrecnbr)).to include "Bldrecnbr has already been taken"
    end
  end

  context "create building with a duplicated name" do
    it 'raise error "ActiveRecord::RecordInvalid: Validation failed: Name has already been taken"' do
      building = FactoryBot.create(:building)
      building1 = FactoryBot.build(:building, name: building.name)
      expect(building1.valid?).to be_falsy
      expect(building1.errors.full_messages_for(:name)).to include "Name has already been taken"
    end
  end

end
