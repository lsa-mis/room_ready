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
#  archived   :boolean          default(FALSE)
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
