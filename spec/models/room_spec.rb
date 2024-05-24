# == Schema Information
#
# Table name: rooms
#
#  id                :bigint           not null, primary key
#  rmrecnbr          :string
#  room_number       :string
#  room_type         :string
#  floor_id          :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  last_time_checked :datetime
#
require 'rails_helper'

# Tests for the future (floor, etc.) are included (TDD)

RSpec.describe Room, type: :model do

  context "the Factory" do
    it 'is valid' do
      expect(build(:room)).to be_valid
    end
  end

  context "when all required fields are present" do
    it "is valid" do
      floor = create(:floor) # TODO: create the associated floor record first
      room = build(:room, floor: floor)
      expect(room).to be_valid
    end
  end

  context "when required rmrecnbr is not present" do
    it "is invalid" do
      room = build(:room, rmrecnbr: nil)
      room.valid?
      expect(room.errors[:rmrecnbr]).to include("can't be blank")
    end
  end

  context "when required room_number is not present" do
    it "is invalid" do
      room = build(:room, room_number: nil)
      room.valid?
      expect(room.errors[:room_number]).to include("can't be blank")
    end
  end

  context "when required room_type is not present" do
    it "is invalid" do
      room = build(:room, room_type: nil)
      room.valid?
      expect(room.errors[:room_type]).to include("can't be blank")
    end
  end

  context "when associated floor does not exist" do
    it "is invalid" do
      room = build(:room, floor_id: nil)
      expect(room).not_to be_valid
      expect(room.errors[:floor]).to include("must exist")
    end
  end

  context "with duplicated rmrecnbr" do
    it "is invalid" do
      floor = create(:floor)
      create(:room, rmrecnbr: "RM123", floor: floor)
      room_with_duplicate_rmrecnbr = build(:room, rmrecnbr: "RM123", floor: floor)
      room_with_duplicate_rmrecnbr.valid?
      expect(room_with_duplicate_rmrecnbr.errors[:rmrecnbr]).to include("has already been taken")
    end
  end
end